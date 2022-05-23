import 'package:shared_preferences/shared_preferences.dart';

// Set data in shared preferences
Future<void> setDataInSharedPref(String key, String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();

  sharedPref.setString(key, val);
}

// Get data from shared preferences
Future<String?> getDataFromSharedPref(String key) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  var rtnVal = sharedPref.getString(key);

  return rtnVal;
}
