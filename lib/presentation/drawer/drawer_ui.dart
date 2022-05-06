import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/presentation/count_day/count_day_ui.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/drawer/setting_page/settings_ui.dart';
import 'package:hnotes/presentation/components/components_collections.dart';
import 'package:hnotes/presentation/drawer/blockchain_info/blockchain_info_ui.dart';

Widget drawer(BuildContext context, Function(Brightness brightness)? changeTheme) {
  return new Drawer(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        header(context),
        daySince(context),
        blockchainInfo(context),
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
  daysBloc.fetchLoveStartDate();
  return DrawerHeader(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/Images/splash-bg.png"),
        fit: BoxFit.fitWidth,
      ),
    ),
    child: GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (context) => CountDay(isSplash: false)
        );
        Navigator.push(context, route);
      },
      child: Center(
        child: Text(
          "$globalDayCount",
          style: TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    )
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
        builder: (context) => CountDay(isSplash: false)
      );
      Navigator.push(context, route);
    },
  );
}

Widget blockchainInfo(BuildContext context) {
  return ListTile(
    leading: Icon(
      Icons.cloud,
      color: btnColor,
    ),
    title: Text(
      'Blockchain Info',
      style: TextStyle(
        fontSize: subtitleFontSize,
        fontWeight: itemFontWeight,
      ),
    ),
    onTap: () {
      Navigator.of(context).push(new CupertinoPageRoute(builder: (_) {
        return new BlockchainInfoPage();
      }));
    },
  );
}

Widget settings(BuildContext context, Function(Brightness brightness)? changeTheme) {
  return ListTile(
    leading: Icon(
      Icons.settings,
      color: Colors.purpleAccent,
    ),
    title: Text(
      'Settings',
      style: TextStyle(
        fontSize: subtitleFontSize,
        fontWeight: itemFontWeight,
      ),
    ),
    onTap: () {
      Navigator.of(context).push(new CupertinoPageRoute(builder: (_) {
        return new SettingsPage(changeTheme: changeTheme, onlySetDate: false);
      }));
    },
  );
}

Widget version() {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('\n  ${packageInfo.version}  \n'),
      ),
    ),
  );
}
