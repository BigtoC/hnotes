import "package:rxdart/rxdart.dart";

import "package:hnotes/domain/theme/theme_model.dart";
import "package:hnotes/infrastructure/local_storage/theme/theme_repository.dart";


class ThemeBloc {
  final _themeRepository = ThemeRepository();
  final _themeModel = PublishSubject<ThemeModel>();

  Stream<ThemeModel> get themeModel => _themeModel.stream;

  fetchStoredTheme() async {
    ThemeModel theme = await _themeRepository.getSavedTheme();
    _themeModel.sink.add(theme);
  }

  void dispose() {
    _themeModel.close();
  }
}

final themeBloc = ThemeBloc();
