import 'package:flutter/material.dart';
import 'package:hnotes/drawer/settings_ui.dart';
import 'package:hnotes/SplashScreen/days_since_ui.dart';
import 'package:hnotes/components/components_collections.dart';

Widget drawer(BuildContext context, Function(Brightness brightness) changeTheme) {
  return new Drawer(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        header(),
        daySince(context),
        settings(context, changeTheme),
        sizeBox(context, 0.1),
        divider(context, 0.5),
        version(),
      ],
    ),
  );
}

final double subtitleFontSize = 18.0;
final itemFontWeight = FontWeight.w400;

Widget header() {
  return DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.blueAccent,
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

Widget settings(BuildContext context, Function(Brightness brightness) changeTheme) {
  return ListTile(
    leading: Icon(Icons.settings),
    title: Text(
      'Settings',
      style: TextStyle(
        fontSize: subtitleFontSize,
        fontWeight: itemFontWeight,
      ),
    ),
    onTap: () {
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
        return new SettingsPage(changeTheme: changeTheme, onlySetDate: false);
      }));
    },
  );
}

Widget version() {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Text('\n  0.0.1 Dev\n'),
    ),
  );
}

