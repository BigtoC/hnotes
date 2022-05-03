import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/requester/repository.dart';
import 'package:hnotes/util/share_preferences.dart';
import 'package:hnotes/splash_screen/days_since_ui.dart';
import 'package:hnotes/drawer/setting_page/settings_ui.dart';

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
  Repository repository = new Repository();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    updateThemeFromSharedPref();
    createFolderInAppDocDir("hnotes");
    // repository.chainCall().handShake();
    getDateSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: packageInfo.appName,
      theme: theme,
//      home: DaySince(isSplash: true, changeTheme: setTheme),
      home: dateIsSet
        ? DaySince(isSplash: true, changeTheme: setTheme, key: null,)
        : SettingsPage(changeTheme: setTheme, onlySetDate: true),
    );
  }

  void getDateSuccess() async{
    if (globalLoveStartDate != " ") {
      setState(() {
        dateIsSet = true;
      });
    }
    else {
      setState(() {
        dateIsSet = false;
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
    String themeText = await getDataFromSharedPref('theme');
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
