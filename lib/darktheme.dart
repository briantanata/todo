import 'package:flutter/material.dart';

class DarkThemeProvider with ChangeNotifier {
  var light =
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.yellow);

  var dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
  );

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkMode(bool value) {
    _darkTheme = value;
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
          .copyWith(background: isDarkTheme ? Colors.black : Color(0xffF1F5FB)),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
