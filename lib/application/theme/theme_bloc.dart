import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/theme/theme_model.dart';
import 'package:hnotes/infrastructure/local_storage/theme/theme_repository.dart';


class ThemeBloc {
  final _themeRepository = new ThemeRepository();
  final _themeModel = new PublishSubject<ThemeModel>();

  Stream<ThemeModel> get themeModel => _themeModel.stream;

  fetchStoredTheme() async {
    ThemeModel _theme = await _themeRepository.getSavedTheme();
    _themeModel.sink.add(_theme);
  }

  void dispose() {
    _themeModel.close();
  }
}

final themeBloc = new ThemeBloc();
