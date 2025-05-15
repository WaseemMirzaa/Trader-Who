import 'package:flutter_bloc/flutter_bloc.dart';

/// Enum representing the app's theme.

enum AppTheme {
  /// Light theme
  light,

  /// Dark theme
  dark,
}

///Class that manages the app's theme state using the Cubit.
class ThemeCubit extends Cubit<AppTheme> {
  /// Constructor for the ThemeCubit.
  ThemeCubit() : super(AppTheme.light);

  /// Toggles the theme between light and dark.
  void toggleTheme() {
    emit(state == AppTheme.light ? AppTheme.dark : AppTheme.light);
  }
}
