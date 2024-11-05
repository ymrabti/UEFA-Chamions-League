part of 'main_theme.dart';

extension ColorX on Color {
  Color invers(bool reverse) {
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

MaterialColor _primaryColorLight = MaterialColor(0xff00cafc, {
  50: Color(0xffdff6fe),
  100: Color(0xfface8fc),
  200: Color(0xff70d9fc),
  300: Color(0xff00cafc),
  400: Color(0xff00befe),
  500: Color(0xff00b1ff),
  600: Color(0xff00a3f0),
  700: Color(0xff0090dd),
  800: Color(0xff007ec9),
  900: Color(0xff005ea9),
});
MaterialColor _secondaryColorLight = MaterialColor(0xff004cfc, {
  50: Color(0xffe9eaff),
  100: Color(0xffc7cbff),
  200: Color(0xff9fa9ff),
  300: Color(0xff7186ff),
  400: Color(0xff4969ff),
  500: Color(0xff004cfc),
  600: Color(0xff0042f0),
  700: Color(0xff0037e3),
  800: Color(0xff002ad8),
  900: Color(0xff0007c9),
});
// // // //
MaterialColor _primaryColorDark = MaterialColor(0xff003846, {
  50: Color(0xffd6f4ff),
  100: Color(0xffb6deeb),
  200: Color(0xff97c5d5),
  300: Color(0xff76abbe),
  400: Color(0xff5c97ac),
  500: Color(0xff3f859a),
  600: Color(0xff337589),
  700: Color(0xff246173),
  800: Color(0xff164d5e),
  900: Color(0xff003846),
});
MaterialColor _secondaryColorDark = MaterialColor(0xff001546, {
  50: Color(0xffe4e6ee),
  100: Color(0xffbac1d6),
  200: Color(0xff8e99ba),
  300: Color(0xff64739e),
  400: Color(0xff45578c),
  500: Color(0xff223c7b),
  600: Color(0xff1c3673),
  700: Color(0xff132d68),
  800: Color(0xff0a245c),
  900: Color(0xff001546),
});
//
MaterialColor textColor = MaterialColor(0xff393939, {
  50: Color(0xfff9f9f9),
  100: Color(0xfff1f1f1),
  200: Color(0xffe8e8e8),
  300: Color(0xffd7d7d7),
  400: Color(0xffb3b3b3),
  500: Color(0xff939393),
  600: Color(0xff6b6b6b),
  700: Color(0xff585858),
  800: Color(0xff393939),
  900: Color(0xff191919),
});
