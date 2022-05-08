import 'package:flutter/material.dart';
import 'package:hnotes/presentation/theme.dart';

class ThemeModel {
  /// Default value is an empty string
  String themeText;
  Brightness brightness;
  ThemeData appTheme;

  ThemeModel(this.themeText, this.brightness, this.appTheme);

  factory ThemeModel.fromAttribute(String? storedTheme) {
    final String _defaultTheme = "dark";

    final Map<String, Map<String, dynamic>> themeTypes = {
      "light": {
        "brightness": Brightness.light,
        "themeDate": appThemeLight
      },
      "dark": {
        "brightness": Brightness.dark,
        "themeDate": appThemeDark
      }
    };

    Brightness? _storedBrightness = themeTypes[storedTheme]?["brightness"];
    ThemeData? _storedThemeData = themeTypes[storedTheme]?["themeDate"];

    if (storedTheme != null && _storedBrightness != null && _storedThemeData != null) {
      return ThemeModel(storedTheme, _storedBrightness, _storedThemeData);
    } else {
      return ThemeModel(
          _defaultTheme,
          themeTypes[_defaultTheme]?["brightness"]!,
          themeTypes[_defaultTheme]?["themeDate"]!
      );
    }
  }
}
