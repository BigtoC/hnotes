import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/drawer/settings_ui.dart';
import 'package:hnotes/SplashScreen/days_since_ui.dart';
import 'package:hnotes/SplashScreen/count_day_model.dart';
import 'package:hnotes/components/components_collections.dart';

Widget drawer(BuildContext context, Function(Brightness brightness) changeTheme) {
  return new Drawer(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        header(context),
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

Widget header(BuildContext context) {
  int dayCount = CountDayModel.daysSince;
  return DrawerHeader(
    decoration: BoxDecoration(
//      color: primaryColor,
      image: DecorationImage(
        image: AssetImage("assets/Images/splash-bg.png"),
        fit: BoxFit.fitWidth,
      ),
    ),
    child: GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (context) => DaySince(isSplash: false)
        );
        Navigator.push(context, route);
      },
      child: Center(
        child: Text(
          "$dayCount",
          style: TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget daySince(BuildContext context) {
  return ListTile(
    leading: Icon(
      Icons.favorite,
      color: primaryColor,
    ),
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
    leading: Icon(
      Icons.settings,
      color: btnColor,
    ),
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

