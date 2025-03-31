import "package:hnotes/domain/theme/theme_model.dart";
import "package:hnotes/infrastructure/local_storage/shared_preferences.dart";


class ThemeRepository {
  static final String _themeSharedPrefKey = "theme";

  Future<ThemeModel> getSavedTheme() async {
    String? storedThemeText = await getDataFromSharedPref(_themeSharedPrefKey);
    ThemeModel theme = ThemeModel.fromAttribute(storedThemeText);
    return theme;
  }

  static void saveThemeInLocal(String? value) {
    if (value != null) {
      setDataInSharedPref(_themeSharedPrefKey, value);
    }
  }
}
