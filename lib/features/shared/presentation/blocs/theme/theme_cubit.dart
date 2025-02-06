import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';

enum ThemeModeState { light, dark }

class ThemeCubit extends Cubit<ThemeModeState> {
  ThemeCubit() : super(ThemeModeState.light);

  void setLightTheme() => emit(ThemeModeState.light);

  void setDarkTheme() => emit(ThemeModeState.dark);

  void toggleTheme() {
    emit(state == ThemeModeState.light
        ? ThemeModeState.dark
        : ThemeModeState.light);
  }

  ThemeData get currentTheme {
    return state == ThemeModeState.light ? AppTheme.light : AppTheme.dark;
  }
}
