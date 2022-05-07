import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/theme/theme_model.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';


class ThemeRepository {
  Future<ThemeModel> getStoredTheme() async {
    String? _storedThemeText = await getDataFromSharedPref(themeKey);
    ThemeModel _theme = ThemeModel.fromAttribute(_storedThemeText);
    return _theme;
  }
}
