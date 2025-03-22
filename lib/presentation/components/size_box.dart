import 'package:flutter/material.dart';

Widget sizeBox(BuildContext context, double size) {
  return SizedBox(
    height: MediaQuery.of(context).size.width * size,  // Set height with percentage
  );
}
