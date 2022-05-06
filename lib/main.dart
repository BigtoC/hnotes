import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/presentation/count_day/count_day_ui.dart';
import 'package:hnotes/presentation/drawer/setting_page/settings_ui.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';
import 'package:hnotes/application/blockchain_info/blockchain_info_bloc.dart';
import 'package:hnotes/infrastructure/local_storage/start_day/start_day_repository.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeData theme = appThemeLight;
  late bool dateIsSet;

  @override
  void initState() {
    super.initState();
    updateThemeFromSharedPref();
    getDateSuccess();
    _initPackageInfo();
    createFolderInAppDocDir("hnotes");
    blockchainInfoBloc.fetchNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(new Duration(milliseconds: 2000));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: packageInfo.appName,
      theme: theme,
      home: dateIsSet
        ? CountDay(isSplash: true, changeTheme: setTheme)
        : SettingsPage(changeTheme: setTheme, onlySetDate: true),
    );
  }

  void getDateSuccess() async {
    final _repository = new StartDayRepository();
    String? _startDate = await _repository.getLoveStartDate();

    if (_startDate.isEmpty) {
      setState(() {
        globalLoveStartDate = "";
        dateIsSet = false;
      });
    }
    else {
      setState(() {
        dateIsSet = true;
      });
    }
  }

  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight;
      });
    }
  }

  void updateThemeFromSharedPref() async {
    String? themeText = await getDataFromSharedPref('theme');
    if (themeText == 'light') {
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {

    // Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();

    // App Document Directory + folder name
    final Directory _appDocDirFolder =  Directory('${_appDocDir.path}/$folderName/');

    // if folder already exists return path
    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    }
    else{  // if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

}
