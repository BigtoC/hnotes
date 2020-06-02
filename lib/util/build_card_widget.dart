import 'package:flutter/material.dart';


Widget buildCardWidget(BuildContext context, Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 8),
          color: Colors.black.withAlpha(20),
          blurRadius: 16)
      ]),
    margin: EdgeInsets.all(24),
    padding: EdgeInsets.all(16),
    child: child,
  );
}
