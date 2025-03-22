import 'package:flutter/material.dart';

List<Color> colorList = [
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.green,
  Colors.teal,
  Colors.amber.shade900,
  Colors.deepOrange,
  Colors.red,
  Colors.purple,
];

Color primaryColor = Colors.pinkAccent.shade200;
Color btnColor = Colors.blueAccent;
Color reallyLightGrey = Colors.grey.withAlpha(25);

ThemeData appThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  textTheme: ThemeData.light().textTheme.apply(fontFamily: 'ZillaSlab'),
);
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  buttonTheme: ButtonThemeData(buttonColor: btnColor),
  textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'ZillaSlab'),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return null;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return null;
    }),
  ),
);
