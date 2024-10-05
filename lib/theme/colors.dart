part of 'main_theme.dart';

const MaterialColor _primaryColorLight = MaterialColor(
  _primaryColorPrimaryValue,
  <int, Color>{
    50: Color(0xFFdff6fe),
    100: Color(0xFFace8fc),
    200: Color(0xFF70d9fc),
    300: Color(_primaryColorPrimaryValue),
    400: Color(0xFF00bdfe),
    500: Color(0xFF00b1fe),
    600: Color(0xFF00a3f0),
    700: Color(0xFF0090dd),
    800: Color(0xFF007ec9),
    900: Color(0xFF005ea8),
  },
);
const int _primaryColorPrimaryValue = 0xFF00c9fc;

const MaterialColor _secondaryColorLight = MaterialColor(
  _secondaryColorPrimaryValue,
  <int, Color>{
    50: Color(0xFFe9eaff),
    100: Color(0xFFc7cbff),
    200: Color(0xFF9fa9ff),
    300: Color(0xFF7186ff),
    400: Color(0xFF4969ff),
    500: Color(_secondaryColorPrimaryValue),
    600: Color(0xFF0042f0),
    700: Color(0xFF0037e3),
    800: Color(0xFF002ad8),
    900: Color(0xFF0007c9),
  },
);
const int _secondaryColorPrimaryValue = 0xFF004cfc;

// // // //

const MaterialColor _primaryColorDark = MaterialColor(
  _primaryColorPrimaryDarkValue,
  <int, Color>{
    50: Color(0xFFd6f4ff),
    100: Color(0xFFb6deeb),
    200: Color(0xFF97c5d5),
    300: Color(0xFF76abbe),
    400: Color(0xFF5c97ac),
    500: Color(0xFF3f859a),
    600: Color(0xFF337589),
    700: Color(0xFF246173),
    800: Color(0xFF164d5e),
    900: Color(_primaryColorPrimaryDarkValue),
  },
);
const int _primaryColorPrimaryDarkValue = 0xFF003846;

const MaterialColor _secondaryColorDark = MaterialColor(
  secondaryColorPrimaryDarkValue,
  <int, Color>{
    50: Color(0xFFe4e6ee),
    100: Color(0xFFbac1d6),
    200: Color(0xFF8e99ba),
    300: Color(0xFF64739e),
    400: Color(0xFF45578c),
    500: Color(0xFF223c7b),
    600: Color(0xFF1c3673),
    700: Color(0xFF132d68),
    800: Color(0xFF0a245c),
    900: Color(secondaryColorPrimaryDarkValue),
  },
);
const int secondaryColorPrimaryDarkValue = 0xFF001546;

MaterialColor textColor = MaterialColor(
  0xFF303030,
  <int, Color>{
    50: Color(0xFFEAEAEA),
    100: Color(0xFFA7A7A7),
    200: Color(0xFF626262),
    300: Color(0xFF626262),
    400: Color(0xFF404040),
    500: Color(0xFF404040),
    600: Color(0xFF303030),
    700: Color(0xFF303030),
    800: Color(0xFF1A1A1A),
    900: Color(0xFF090909),
  },
);

extension ColorX on Color {
  Color transform(bool reverse) {
    return reverse ? Color.fromRGBO(255 - red, 255 - green, 255 - blue, opacity) : this;
  }

  Color darker(int value) {
    return Color.fromRGBO(red - value, green - value, blue - value, opacity);
  }

  Color lighter(int value) {
    return Color.fromRGBO(red + value, green + value, blue + value, opacity);
  }

  Color skin(bool dark, int value) {
    return dark ? lighter(value) : darker(value);
  }

  Color inputFillColor(int value, bool isDarkMode) {
    return isDarkMode ? lighter(value) : darker(value);
  }
}
