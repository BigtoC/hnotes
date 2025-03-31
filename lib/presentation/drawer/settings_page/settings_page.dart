import "package:flutter/material.dart";
import "package:hnotes/domain/theme/theme_model.dart";

import "package:hnotes/presentation/count_day/count_day_ui.dart";
import "package:hnotes/application/count_day/count_day_bloc.dart";
import "package:hnotes/presentation/components/build_card_widget.dart";
import "package:hnotes/presentation/components/page_header_widget.dart";
import "package:hnotes/presentation/drawer/settings_page/about_app_widget.dart";
import "package:hnotes/infrastructure/local_storage/theme/theme_repository.dart";
import "package:hnotes/presentation/drawer/settings_page/select_date_widget.dart";
import "package:hnotes/presentation/drawer/settings_page/input_secret_widget.dart";

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  Function(ThemeData themeData)? changeTheme;
  bool? onlySetDate;

  SettingsPage({super.key, this.changeTheme, required bool this.onlySetDate});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String? selectedTheme;

  @override
  void initState() {
    super.initState();
    daysBloc.fetchLoveStartDate();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      selectedTheme =
          Theme.of(context).brightness == Brightness.dark ? "dark" : "light";
    });

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: handleBack,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                child: PageHeaderWidget(title: "Setting"),
              ),
              widgets(),
            ],
          ),
        ],
      ),
    );
  }

  Widget widgets() {
    return Column(
      children: [
        SelectDateWidget(),
        buildAppThemeChoice(),
        InputApiSecretWidget(),
        AboutAppWidget(),
      ],
    );
  }

  void handleBack() {
    if (widget.onlySetDate == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return CountDay(
              isSplash: true,
              changeTheme: widget.changeTheme,
              key: null,
            );
          },
        ),
      );
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
          cardTitle("App Theme"),
          Container(height: 20),
          Row(
            children: <Widget>[
              Radio(
                value: "light",
                groupValue: selectedTheme,
                onChanged: handleThemeSelection,
              ),
              Text("Light theme", style: TextStyle(fontSize: 18)),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: "dark",
                groupValue: selectedTheme,
                onChanged: handleThemeSelection,
              ),
              Text("Dark theme", style: TextStyle(fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  void handleThemeSelection(String? value) {
    setState(() {
      selectedTheme = value;
    });
    ThemeModel themeModel = ThemeModel.fromAttribute(value);
    widget.changeTheme!(themeModel.appTheme);
    ThemeRepository.saveThemeInLocal(value);
  }
}
