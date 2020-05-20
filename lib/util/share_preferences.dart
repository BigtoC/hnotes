import 'package:shared_preferences/shared_preferences.dart';

void setThemeInSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('theme', val);
}

Future<String> getThemeFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('theme');
}

void setDateInSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('startDate', val);
}

Future<String> getDateFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('startDate');
}
