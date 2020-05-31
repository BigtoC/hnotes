import 'package:shared_preferences/shared_preferences.dart';

// Set theme when app start up
void setThemeInSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('theme', val);
}

Future<String> getThemeFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('theme');
}

// Set date
void setDateInSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('startDate', val);
}

Future<String> getDateFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('startDate');
}

// Store the token
void setTokenInSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('token', val);
}

Future<String> getTokenFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('token');
}
