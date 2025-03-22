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
import 'package:hnotes/infrastructure/local_storage/theme/theme_repository.dart';
import 'package:hnotes/infrastructure/local_storage/files/nft_file_repository.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late bool dateIsSet;
  ThemeData theme = appThemeLight;
  final NftFileRepository _nftFileRepository = NftFileRepository();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _updateThemeFromSharedPref();
    daysBloc.fetchLoveStartDate();
    _nftFileRepository.createNftFolders();
    colorList.shuffle();
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
            bool dateIsSet = snapshot.data?.loveStartDate != "";
            return dateIsSet
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
    final themeRepository = ThemeRepository();
    ThemeModel theme = await themeRepository.getSavedTheme();
    setTheme(theme.appTheme);
  }

  Future<String> createFolderInAppDocDir(String folderName) async {

    // Get this App Document Directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // App Document Directory + folder name
    final Directory appDocDirFolder =  Directory('${appDocDir.path}/$folderName/');

    // if folder already exists return path
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    }
    else{  // if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder=await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }
}
