import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/theme/theme_model.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';


class ThemeRepository {
  static String _themeKey = "theme";

  Future<ThemeModel> getSavedTheme() async {
    String? _storedThemeText = await getDataFromSharedPref(_themeKey);
    ThemeModel _theme = ThemeModel.fromAttribute(_storedThemeText);
    return _theme;
  }

  static void saveThemeInLocal(String? value) {
    if (value != null) {
      setDataInSharedPref(_themeKey, value);
    }
  }
}
