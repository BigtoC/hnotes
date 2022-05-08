import 'package:hnotes/domain/theme/theme_model.dart';
import 'package:hnotes/infrastructure/local_storage/shared_preferences.dart';


class ThemeRepository {
  static String _themeSharedPrefKey = "theme";

  Future<ThemeModel> getSavedTheme() async {
    String? _storedThemeText = await getDataFromSharedPref(_themeSharedPrefKey);
    ThemeModel _theme = ThemeModel.fromAttribute(_storedThemeText);
    return _theme;
  }

  static void saveThemeInLocal(String? value) {
    if (value != null) {
      setDataInSharedPref(_themeSharedPrefKey, value);
    }
  }
}
