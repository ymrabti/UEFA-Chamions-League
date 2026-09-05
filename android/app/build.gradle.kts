import com.android.build.gradle.internal.api.BaseVariantOutputImpl
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load version from version.properties (separate file so flutter pub get can't clobber it)
val versionPropsFile = rootProject.file("version.properties")
val versionProps = Properties()
if (versionPropsFile.exists()) {
    versionPropsFile.inputStream().use { versionProps.load(it) }
}

val currentVersionCode = (versionProps.getProperty("versionCode") ?: "1").toInt()
val currentVersionName = versionProps.getProperty("versionName") ?: "1.0.0"

// Load signing config from key.properties (separate file so flutter pub get can't clobber it)
val keyPropsFile = rootProject.file("key.properties")
val keyProps = Properties()
if (keyPropsFile.exists()) {
    keyPropsFile.inputStream().use { keyProps.load(it) }
}

val releaseStoreFile = keyProps.getProperty("storeFile")
val releaseStorePassword = keyProps.getProperty("storePassword")
val releaseKeyAlias = keyProps.getProperty("keyAlias")
val releaseKeyPassword = keyProps.getProperty("keyPassword")

// Version bumping task for release builds
tasks.register("bumpVersion") {
    doLast {
        val newVersionCode = currentVersionCode + 1

        val parts = currentVersionName.split(".")
        var major = parts[0].toInt()
        var minor = parts[1].toInt()
        var patch = parts[2].toInt()

        patch++
        if (patch >= 100) {
            patch = 0
            minor++
        }
        if (minor >= 100) {
            minor = 0
            major++
        }

        val newVersionName = "$major.$minor.$patch"

        println(">>> Bumped versionName: $currentVersionName → $newVersionName")
        println(">>> Bumped versionCode: $currentVersionCode → $newVersionCode")

        versionProps["versionCode"] = newVersionCode.toString()
        versionProps["versionName"] = newVersionName
        versionPropsFile.outputStream().use { versionProps.store(it, null) }
    }
}

// Make release builds depend on version bump
tasks.matching { it.name == "assembleRelease" || it.name == "bundleRelease" }.configureEach {
    dependsOn("bumpVersion")
}

// Rename AAB outputs after bundleRelease completes
tasks.whenTaskAdded {
    if (name == "bundleRelease") {
        doLast {
            val date = SimpleDateFormat("yyMMdd.HHmm").format(Date())
            val bundleDir = file("${project.layout.buildDirectory.get()}/outputs/bundle/release")
            bundleDir.listFiles()?.filter { it.extension == "aab" }?.forEach { aabFile ->
                val newName = "botola-max-$date-v$currentVersionName+$currentVersionCode-release.aab"
                val newFile = File(aabFile.parentFile, newName)
                if (aabFile.renameTo(newFile)) {
                    println(">>> Renamed AAB: ${aabFile.name} → $newName")
                } else {
                    println(">>> Failed to rename AAB: ${aabFile.name}")
                }
            }
        }
    }
}

android {
    namespace = "com.ymrabtiapps.botola_max"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    // cls && gradlew clean && gradlew build

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    
    defaultConfig {
        applicationId = "com.ymrabtiapps.botola_max"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = currentVersionCode
        versionName = currentVersionName
        multiDexEnabled = true
    }

    val hasSigningConfig = releaseStoreFile != null &&
        releaseStorePassword != null &&
        releaseKeyAlias != null &&
        releaseKeyPassword != null

    signingConfigs {
        if (hasSigningConfig) {
            create("release") {
                storeFile = file(releaseStoreFile!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    applicationVariants.all {
        val variantName = name
        val versionCodeValue = versionCode
        val versionNameValue = versionName

        outputs.all {
            val date = SimpleDateFormat("yyMMdd.HHmm").format(Date())
            val arch = filters.find {
                it.filterType == com.android.build.api.variant.FilterConfiguration.FilterType.ABI.name
            }?.identifier ?: "universal"
            val newName = "botola-max-$date-v$versionNameValue+$versionCodeValue-$variantName-$arch.apk"
            (this as BaseVariantOutputImpl).outputFileName = newName
        }
    }

    buildTypes {
        getByName("release") {
            if (hasSigningConfig) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}


kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

