import 'package:flutter/material.dart';
import 'package:hnotes/presentation/theme.dart';

class ThemeModel {
  /// Default value is an empty string
  String themeText;
  Brightness brightness;
  ThemeData appTheme;

  ThemeModel(this.themeText, this.brightness, this.appTheme);

  factory ThemeModel.fromAttribute(String? storedTheme) {
    final String defaultTheme = "dark";

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

    Brightness? storedBrightness = themeTypes[storedTheme]?["brightness"];
    ThemeData? storedThemeData = themeTypes[storedTheme]?["themeDate"];

    if (storedTheme != null && storedBrightness != null && storedThemeData != null) {
      return ThemeModel(storedTheme, storedBrightness, storedThemeData);
    } else {
      return ThemeModel(
          defaultTheme,
          themeTypes[defaultTheme]?["brightness"]!,
          themeTypes[defaultTheme]?["themeDate"]!
      );
    }
  }
}
