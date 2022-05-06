import 'package:shared_preferences/shared_preferences.dart';

// Set data in shared preferences
void setDataInSharedPref(String key, String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();

  while (null == sharedPref) {
    await new Future.delayed(new Duration(milliseconds: 50));
  }

  sharedPref.setString(key, val);
}

// Get data from shared preferences
Future<String> getDataFromSharedPref(String key) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  var rtnVal = sharedPref.getString(key);

  while (null == rtnVal) {
    await new Future.delayed(new Duration(milliseconds: 50));
  }

  return rtnVal;
}
