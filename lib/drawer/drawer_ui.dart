import 'package:flutter/material.dart';
import 'package:hnotes/SplashScreen/days_since.dart';
import 'package:hnotes/util/util_collections.dart';
import 'package:hnotes/drawer/app_repo.dart';

Widget drawer(BuildContext context) {
  return new Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        header(),
        daySince(context),
        gitRepo(context),
        sizeBox(context, 0.1),
        divider(context, 0.5),
      ],
    ),
  );
}

final double subtitleFontSize = 18.0;
final itemFontColor = Colors.black87;
final itemFontWeight = FontWeight.w400;

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
        color: itemFontColor,
        fontWeight: itemFontWeight,
      ),
    ),
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (context) => DaySince(isSplash: false)
      );
      Navigator.push(context, route);
    },
  );
}

Widget gitRepo(BuildContext context) {
  return ListTile(
    title: Text(
      'Source Codes',
      style: TextStyle(
        fontSize: subtitleFontSize,
        color: itemFontColor,
        fontWeight: itemFontWeight,
      ),
    ),
    onTap: () {
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
        return new Browser();
      }));
    },
  );
}
