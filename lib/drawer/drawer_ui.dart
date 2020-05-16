import 'package:flutter/material.dart';
import 'package:hnotes/SplashScreen/days_since.dart';
import 'package:hnotes/util/util_collections.dart';
import 'package:hnotes/drawer/app_repo.dart';

Widget drawer(BuildContext context) {
  return new Drawer(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        header(),
        daySince(context),
        gitRepo(context),
        sizeBox(context, 0.1),
        divider(context, 0.5),
        version(),
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
      child: const Text(
        "hNotes",
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
    leading: Icon(Icons.favorite),
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
    leading: Icon(Icons.code),
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

Widget version() {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Text('\n  0.0.1 Alpha\n'),
    ),
  );
}

