import 'package:flutter/material.dart';

Color primaryColor = Colors.blueAccent;
Color reallyLightGrey = Colors.grey.withAlpha(25);
//String fontFamily = 'ZillaSlab';
ThemeData appThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'ZillaSlab',
  ),
);
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  toggleableActiveColor: primaryColor,
  accentColor: primaryColor,
  buttonColor: primaryColor,
  textSelectionColor: primaryColor,
  textSelectionHandleColor: primaryColor,
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'ZillaSlab',
  ),
);

