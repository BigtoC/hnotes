import 'package:flutter/material.dart';
import 'package:hnotes/SplashScreen/days_since.dart';

Widget drawer(BuildContext context) {
  return new Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        header(),
        daySince(context),
      ],
    ),
  );
}

final double subtitleFontSize = 18.0;

Widget header() {
  return DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.lightBlue,
    ),
    child: Center(
      child: Text(
        "HNotes",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget daySince(BuildContext context) {
  return ListTile(
    title: Text(
      'Day Counts',
      style: TextStyle(
        fontSize: subtitleFontSize,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
    ),
    onTap: () {
      Route route = MaterialPageRoute(builder: (contextAU) => DaySince(isSplash: false));
      Navigator.push(context, route);
    },
  );
}

