import "package:flutter/material.dart";

Widget sizeBox(BuildContext context, double size) {
  return SizedBox(
    // Set height with percentage
    height: MediaQuery.of(context).size.width * size,
  );
}
