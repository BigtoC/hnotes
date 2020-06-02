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
];

Color primaryColor = Colors.pinkAccent.shade200;
Color btnColor = Colors.blueAccent;
Color reallyLightGrey = Colors.grey.withAlpha(25);

ThemeData appThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'ZillaSlab',
  ),
);
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  toggleableActiveColor: primaryColor,
  accentColor: primaryColor,
  buttonColor: btnColor,
  textSelectionColor: primaryColor,
  textSelectionHandleColor: primaryColor,
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'ZillaSlab',
  ),
);

