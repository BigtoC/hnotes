import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/theme/theme_model.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/presentation/count_day/count_day_ui.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/count_day/count_day_background.dart';
import 'package:hnotes/presentation/drawer/settings_page/settings_page.dart';
import 'package:hnotes/application/blockchain_info/blockchain_info_bloc.dart';
import 'package:hnotes/infrastructure/local_storage/theme/theme_repository.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
    _initPackageInfo();
    _updateThemeFromSharedPref();
    daysBloc.fetchLoveStartDate();
    _createFolderInAppDocDir("hnotes");
    blockchainInfoBloc.fetchNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: packageInfo.appName,
      theme: theme,
      home: StreamBuilder(
        stream: daysBloc.dayModel,
        builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            bool _dateIsSet = snapshot.data?.loveStartDate != "";
            return _dateIsSet
                ? CountDay(isSplash: true, changeTheme: setTheme)
                : SettingsPage(changeTheme: setTheme, onlySetDate: true);
          }
          FlutterNativeSplash.remove();
          return countDayBackground();
        }
      )
    );
  }

  setTheme(ThemeData themeData) {
    setState(() {
      theme = themeData;
    });
  }

  Future<void> _updateThemeFromSharedPref() async {
    final _themeRepository = new ThemeRepository();
    ThemeModel _theme = await _themeRepository.getStoredTheme();
    setTheme(_theme.appTheme);
  }

  static Future<String> _createFolderInAppDocDir(String folderName) async {

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
