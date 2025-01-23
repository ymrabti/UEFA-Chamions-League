library theme;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
part 'colors.dart';

const Color transparent = Colors.transparent;
MaterialColor _errorColor = MaterialColor(
  0xFFC2185B,
  <int, Color>{
    050: Color(0xFFF390B8),
    100: Color(0xFFE971A1),
    200: Color(0xFFE25C92),
    300: Color(0xFFDA4581),
    400: Color(0xFFCF3170),
    500: Color(0xFFC2185B),
    600: Color(0xFFAD1150),
    700: Color(0xFF980E45),
    800: Color(0xFF83083A),
    900: Color(0xFF500221),
  },
);
ThemeData mainTheme({required bool dark}) {
  Color shade600 = textColor.shade600;
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: shade600.invers(dark)),
    gapPadding: 10,
  );
  Color bgColor = textColor.shade800.invers(!dark);
  Color fgColor = textColor.invers(dark);
  ColorScheme colorScheme = dark
      ? ColorScheme.dark(
          primary: _primaryColorDark,
          secondary: _secondaryColorDark,
          error: _errorColor,
          background: bgColor,
        )
      : ColorScheme.light(
          primary: _primaryColorLight,
          secondary: _secondaryColorLight,
          error: _errorColor,
          background: bgColor,
        );
  var primaryColor = dark ? _primaryColorDark : _primaryColorLight;
  return ThemeData(
    /* primarySwatch: primaryColor,
    colorSchemeSeed: null,
    fontFamilyFallback: null,
    package: null, */
    fontFamily: 'AppFont',
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: bgColor,
    dialogBackgroundColor: transparent,
    useMaterial3: true,
    typography: Typography(platform: TargetPlatform.iOS),
    colorScheme: colorScheme,
    cardColor: bgColor,
    cardTheme: CardTheme(
      color: bgColor,
      elevation: 3,
      shadowColor: fgColor.withOpacity(0.3),
      shape: Border(),
    ),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      foregroundColor: fgColor,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: fgColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: fgColor,
        weight: 900,
        opticalSize: 96,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: fgColor,
          fontSize: 16,
        ),
      ).bodyMedium,
    ),
    iconTheme: IconThemeData(
      color: fgColor,
      weight: 500,
      fill: 0.4,
      shadows: [
        BoxShadow(
          color: bgColor.withOpacity(0.5),
        ),
      ],
      opticalSize: 64,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgColor.inputFillColor(20, dark),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      errorBorder: outlineInputBorder,
      suffixIconColor: fgColor,
      border: outlineInputBorder,
      disabledBorder: InputBorder.none,
      outlineBorder: BorderSide(),
    ),
    visualDensity: VisualDensity.comfortable,
    //
    textTheme: TextTheme(labelLarge: TextStyle(fontSize: 20, fontFamily: 'AppFont')),
    primaryTextTheme: TextTheme(labelLarge: TextStyle(fontSize: 20, fontFamily: 'AppFont')),
    hintColor: null,
    focusColor: null,
    hoverColor: null,
    shadowColor: fgColor.withOpacity(.035),
    splashColor: null,
    canvasColor: null,
    dividerColor: null,
    primaryColor: primaryColor,
    primaryColorDark: _primaryColorDark,
    primaryColorLight: _primaryColorLight,
    disabledColor: null,
    highlightColor: null,
    indicatorColor: null,
    secondaryHeaderColor: null,
    unselectedWidgetColor: null,
    applyElevationOverlayColor: null,
    actionIconTheme: null,
    badgeTheme: null,
    bannerTheme: null,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
    ),
    bottomNavigationBarTheme: null,
    bottomSheetTheme: null,
    buttonBarTheme: null,
    buttonTheme: null,
    checkboxTheme: null,
    chipTheme: null,
    cupertinoOverrideTheme: null,
    dataTableTheme: null,
    datePickerTheme: null,
    dialogTheme: DialogTheme(
      backgroundColor: bgColor.inputFillColor(35, dark),
      elevation: 0,
      shape: RoundedRectangleBorder(),
    ),
    dividerTheme: null,
    drawerTheme: null,
    elevatedButtonTheme: null,
    expansionTileTheme: ExpansionTileThemeData(
      textColor: fgColor,
      iconColor: fgColor,
      collapsedTextColor: fgColor.inputFillColor(20, dark),
      collapsedIconColor: fgColor,
      backgroundColor: bgColor.inputFillColor(20, dark),
      collapsedBackgroundColor: bgColor.inputFillColor(10, dark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    ),
    extensions: null,
    filledButtonTheme: null,
    floatingActionButtonTheme: null,
    iconButtonTheme: null,
    listTileTheme: ListTileThemeData(
      tileColor: bgColor.inputFillColor(10, dark),
      iconColor: fgColor,
      style: ListTileStyle.list,
      subtitleTextStyle: TextStyle(
        color: fgColor,
        fontStyle: FontStyle.italic,
      ),
      titleTextStyle: TextStyle(
        color: fgColor,
      ),
    ),
    materialTapTargetSize: null,
    menuBarTheme: null,
    menuButtonTheme: null,
    menuTheme: null,
    navigationBarTheme: null,
    navigationDrawerTheme: null,
    navigationRailTheme: null,
    outlinedButtonTheme: null,
    pageTransitionsTheme: null,
    platform: null,
    popupMenuTheme: null,
    primaryIconTheme: IconThemeData(
      color: fgColor,
      weight: 500,
      fill: 0.4,
      shadows: [
        BoxShadow(
          color: bgColor.withOpacity(0.5),
        ),
      ],
      opticalSize: 64,
    ),
    progressIndicatorTheme: null,
    radioTheme: null,
    scrollbarTheme: null,
    searchBarTheme: null,
    searchViewTheme: null,
    segmentedButtonTheme: null,
    sliderTheme: null,
    snackBarTheme: null,
    splashFactory: null,
    switchTheme: null,
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: fgColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
    ),
    textButtonTheme: null,
    textSelectionTheme: null,
    timePickerTheme: TimePickerThemeData(),
    toggleButtonsTheme: null,
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(
        color: fgColor,
        fontSize: 16,
      ),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.inputFillColor(30, dark),
        border: Border.all(color: fgColor.inputFillColor(30, dark), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    // typography: null,
    //
  );
}
