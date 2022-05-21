import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';

class PageHeaderWidget extends StatelessWidget {
  final String title;

  PageHeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36,
          color: primaryColor,
        ),
      ),
    );
  }
}
