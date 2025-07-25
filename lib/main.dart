import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:botola_max/views/loading_splash.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:botola_max/lib.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:wakelock_plus/wakelock_plus.dart';

final DateTime competitionExpire = DateTime.now().subtract(Duration(hours: 24));
final GlobalKey keyTextSlogan = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((BotolaPlatform.isAndroid || BotolaPlatform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
  }
  // await IGenericAppModel.clearAll();
  final SettingsController settingsController = SettingsController();
  await settingsController.loadSettings();
  List<ConnectivityResult> initialConnectivity = await connectivity.checkConnectivity();
  runApp(
    ScreenUtilInit(
      designSize: Size(360.0, 806.0),
      child: ChangeNotifierProvider<AppState>(
        create: (BuildContext context) {
          return AppState(settingsController.fallback, initialConnectivity);
        },
        child: ThemeProvider(
          initTheme: mainTheme(dark: settingsController.isDark),
          builder: (BuildContext context, ThemeData theme) {
            return GetMaterialApp(
              title: 'Botola Max',
              locale: const Locale('en'),
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: Builder(
                builder: (BuildContext context) {
                  Get.put<SettingsController>(settingsController, tag: SharedPreferencesKeys.settingController.name);
                  return SplashScreen();
                },
              ),
            );
          },
        ),
      ),
    ),
  );
}

class AppCheckInitial extends StatefulWidget {
  const AppCheckInitial({
    super.key,
    required this.connectivityResult,
  });
  final ConnectivityResult connectivityResult;
  @override
  State<AppCheckInitial> createState() => _AppCheckInitialState();
}

class _AppCheckInitialState extends State<AppCheckInitial> {
  @override
  Widget build(BuildContext context) {
    bool isConnected = <ConnectivityResult>[
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
      ConnectivityResult.bluetooth,
      ConnectivityResult.vpn,
    ].contains(widget.connectivityResult);
    return ScaffoldBuilder(
      body: isConnected ? SplashScreen() : BotolaOffline(),
    );
  }
}

class BotolaOffline extends StatelessWidget {
  const BotolaOffline({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.signal_wifi_connected_no_internet_4_sharp).toCard(),
            const Gap(20),
            const Icon(Icons.signal_cellular_connected_no_internet_4_bar_rounded).toCard(),
            const Gap(20),
            const Icon(Icons.airplanemode_active_rounded).toCard(),
            /* 
            const Gap(20),
            const Icon(Icons.bluetooth_disabled).toCard(), 
            */
          ],
        ),
      ],
    );
  }
}
