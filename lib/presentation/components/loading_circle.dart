import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? btnColor
          : primaryColor,
    );
  }
}
