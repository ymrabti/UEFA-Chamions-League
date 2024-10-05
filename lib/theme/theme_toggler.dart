import "package:animated_theme_switcher/animated_theme_switcher.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:botola_max/lib.dart";
import "package:get/get.dart";

class ThemeModeToggler extends StatefulWidget {
  ThemeModeToggler({Key? key}) : super(key: key);

  @override
  State<ThemeModeToggler> createState() => _ThemeModeTogglerState();
}

class _ThemeModeTogglerState extends State<ThemeModeToggler> {
  final GlobalKey glbDrk = GlobalKey();
  final GlobalKey glbLgh = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(milliseconds: 500);
    return ThemeSwitcher(
      builder: (context) {
        return AnimatedSwitcher(
          duration: duration,
          reverseDuration: duration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
            );
          },
          child: IconButton(
            key: Get.isDarkMode ? glbDrk : glbLgh,
            tooltip: 'Toggle Theme',
            onPressed: () async {
              SettingsController settingController = Get.find<SettingsController>(tag: SharedPreferencesKeys.settingController.name);
              RenderObject? boundary = context.findRenderObject();
              if (boundary == null) return;
              bool debugNeedsPaint = false;
              if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;
              if (debugNeedsPaint) return;
              final bool prevDark = Get.isDarkMode;
              //   bool prevDark = Theme.of(context).brightness == Brightness.dark;
              await settingController.updateThemeMode(prevDark ? Brightness.light : Brightness.dark);
              if (!mounted) return;
              ThemeData newTheme = mainTheme(dark: !prevDark);
              ThemeSwitcher.of(context).changeTheme(theme: newTheme, isReversed: !prevDark);
              Get.changeTheme(newTheme);
            },
            icon: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.wb_sunny_outlined,
            ),
          ),
        );
      },
      clipper: ThemeSwitcherCircleClipper(),
    );
  }
}

class CustomThemeSwitchingArea extends StatelessWidget {
  CustomThemeSwitchingArea({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: ((context) => child),
      ),
    );
  }
}

/*
SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
    statusBarColor: store.state.primaryColor,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: store.state.primaryColor,
    ),
); */

/* RenderBox box = buildContext.findRenderObject() as RenderBox;
Offset position = box.localToGlobal(Offset.zero); //this is global position
double x = position.dx;
double y = position.dy;
log( {'x': x, 'y': y});
*/
