import 'dart:async';
import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/presentation/count_day/count_day_ui.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/components/build_card_widget.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';
import 'package:hnotes/presentation/drawer/setting_page/about_app_widget.dart';


// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  Function(Brightness brightness)? changeTheme;
  bool? onlySetDate;
  SettingsPage({
    Key? key,
    required Function(Brightness brightness)? changeTheme,
    required bool onlySetDate
  })
    : super(key: key) {
    this.changeTheme = changeTheme;
    this.onlySetDate = onlySetDate;
  }
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? selectedTheme;
  String _selectedDate = "";

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
                buildDatePicker(),
                buildAppThemeChoice(),
                new AboutApp(),
              ],
            ))
        ],
      ),
    );
  }

  void handleBack() {
    if (widget.onlySetDate == true) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
        return new CountDay(isSplash: true, changeTheme: widget.changeTheme, key: null,);
      }));
    }
    else {
      Navigator.pop(context);
    }
  }

  Widget buildDatePicker() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      primary: btnColor,
    );

    return buildCardWidget(context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardTitle('Love Start Date'),
          Container(
            height: 20,
          ),
          Center(
            child: new Column(
              children: <Widget>[
                new ElevatedButton(
                  style: style,
                  onPressed: _selectDate,
                  child: StreamBuilder(
                      stream: daysBloc.dayModel,
                      builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
                        String buttonPlaceholder = "Select Date";
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          String storedStartDate = snapshot.data?.loveStartDate == null ? buttonPlaceholder : snapshot.data!.loveStartDate;
                          return _selectDateText(storedStartDate);
                        }
                        return _selectDateText(buttonPlaceholder);
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _selectDateText(String text) {
    return new Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        )
    );
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1966),
      lastDate: new DateTime.now()
    );
    if (picked != null) {
      // Convert selected date to string for showing
      setState(() => {
        _selectedDate = picked.toString().split(" ")[0],
      });
      globalLoveStartDate = _selectedDate;

      // Write the selected date to system
      setDataInSharedPref(startDateKey, _selectedDate);
      await daysBloc.fetchLoveStartDate();
    }
  }

  Widget buildAppThemeChoice() {
    return buildCardWidget(context,
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
      )
    );
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
