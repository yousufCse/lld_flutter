import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(mode: ThemeMode.system));

  bool get isDarkMode => state.mode == ThemeMode.dark;
  bool get isLightMode => state.mode == ThemeMode.light;
  bool get isSystemMode => state.mode == ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    emit(ThemeState(mode: mode));
  }

  void toggleTheme() {
    if (isDarkMode) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}
