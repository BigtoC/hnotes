import 'package:flutter/material.dart';

Widget divider(BuildContext context, double height) {
  return SizedBox(
    child: Center(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(
              context,
              color: Colors.grey
            ),
          ),
        ),
      ),
    ),
  );
}
