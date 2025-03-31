import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "package:hnotes/domain/common_data.dart";
import "package:hnotes/presentation/components/browser.dart";
import "package:hnotes/domain/count_day/count_day_model.dart";
import "package:hnotes/presentation/count_day/count_day_ui.dart";
import "package:hnotes/application/count_day/count_day_bloc.dart";
import "package:hnotes/presentation/components/components_collections.dart";
import "package:hnotes/presentation/drawer/settings_page/settings_page.dart";
import "package:hnotes/presentation/drawer/blockchain_info/blockchain_info_ui.dart";

// ignore: must_be_immutable
class DrawerWidget extends StatelessWidget {
  Function(ThemeData themeData)? changeTheme;

  DrawerWidget(this.changeTheme, {super.key});

  final double subtitleFontSize = 18.0;
  final itemFontWeight = FontWeight.w400;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          header(context),
          navigatorTab(
            context,
            Icons.favorite,
            Colors.pinkAccent,
            "Day Counts",
            tapDayCount,
          ),
          navigatorTab(
            context,
            Icons.cloud,
            Colors.blueAccent,
            "Blockchain Info",
            tapBlockchain,
          ),
          navigatorTab(
            context,
            Icons.settings,
            Colors.purpleAccent,
            "Settings",
            tapSettings,
          ),
          navigatorTab(
            context,
            Icons.book,
            Colors.green,
            "Usage Guide",
            tapUsageGuide,
          ),
          sizeBox(context, 0.1),
          divider(context, 0.5),
          version(),
        ],
      ),
    );
  }

  Widget header(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Images/heart-bg.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: StreamBuilder(
        stream: daysBloc.dayModel,
        builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.hasData) {
            int? daySince = snapshot.data?.dayCount;
            return _dayCountNumber(context, daySince.toString());
          }
          return Center(
            child: _dayCountNumber(context, globalDayCount.toString()),
          );
        },
      ),
    );
  }

  Widget _dayCountNumber(BuildContext context, String number) {
    return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (context) => CountDay(isSplash: false),
        );
        Navigator.push(context, route);
      },
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget navigatorTab(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    Function(BuildContext context) onTapAction,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: subtitleFontSize,
          fontWeight: itemFontWeight,
        ),
      ),
      onTap: () {
        onTapAction(context);
      },
    );
  }

  void tapDayCount(BuildContext context) {
    Route route = MaterialPageRoute(
      builder: (context) => CountDay(isSplash: false),
    );
    Navigator.push(context, route);
  }

  void tapBlockchain(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) {
          return BlockchainInfoPage();
        },
      ),
    );
  }

  void tapSettings(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) {
          return SettingsPage(changeTheme: changeTheme, onlySetDate: false);
        },
      ),
    );
  }

  void tapUsageGuide(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Browser(
            title: "hnotes README",
            url: "https://github.com/BigtoC/hnotes/blob/main/README.md#hnotes",
          );
        },
      ),
    );
  }

  Widget version() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "\n  ${packageInfo.version}+${packageInfo.buildNumber}  \n",
          ),
        ),
      ),
    );
  }
}
