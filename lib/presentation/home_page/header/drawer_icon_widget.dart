import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';

class DrawerIcon extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerIcon({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.only(top: 16, bottom: 10, right: 20),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.menu,
              color: primaryColor,
              size: 31,
            ),
          ),
        ),
      ],
    );
  }
}
