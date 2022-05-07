import 'package:flutter/material.dart';

import 'package:hnotes/presentation/count_day/count_day_ui.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/components/build_card_widget.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';
import 'package:hnotes/presentation/drawer/settings_page/about_app_widget.dart';
import 'package:hnotes/presentation/drawer/settings_page/select_date_widget.dart';


// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  Function(Brightness brightness)? changeTheme;
  bool? onlySetDate;

  SettingsPage(
      {Key? key, required Function(Brightness brightness)? changeTheme, required bool onlySetDate})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.onlySetDate = onlySetDate;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? selectedTheme;

  @override
  void initState() {
    super.initState();
    daysBloc.fetchLoveStartDate();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (Theme.of(context).brightness == Brightness.dark) {
        selectedTheme = 'dark';
      } else {
        selectedTheme = 'light';
      }
    });

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    handleBack();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                  child: buildHeaderWidget('Settings'),
                ),
                new SelectDateWidget(),
                buildAppThemeChoice(),
                new AboutAppWidget(),
              ],
            ))
        ],
      ),
    );
  }

  void handleBack() {
    if (widget.onlySetDate == true) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
        return new CountDay(
          isSplash: true,
          changeTheme: widget.changeTheme,
          key: null,
        );
      }));
    } else {
      Navigator.pop(context);
    }
  }

  Widget buildAppThemeChoice() {
    return buildCardWidget(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            cardTitle('App Theme'),
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'light',
                  groupValue: selectedTheme,
                  onChanged: handleThemeSelection,
                ),
                Text(
                  'Light theme',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'dark',
                  groupValue: selectedTheme,
                  onChanged: handleThemeSelection,
                ),
                Text(
                  'Dark theme',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ],
        ));
  }

  void handleThemeSelection(String? value) {
    setState(() {
      selectedTheme = value;
    });
    if (value == 'light') {
      widget.changeTheme!(Brightness.light);
    } else {
      widget.changeTheme!(Brightness.dark);
    }
    setDataInSharedPref('theme', value!);
  }
}
