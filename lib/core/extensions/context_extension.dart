import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../config/app_routes.dart';

/// Extension on [BuildContext] to provide easy access to commonly used
/// theme, media query, and screen size properties.
extension ContextExtension on BuildContext {
  /// - [theme]: Accesses the `ThemeData` associated with the current context.
  ThemeData get theme => Theme.of(this);

  /// - `textTheme`: Retrieves the `TextTheme` from the current theme for text styling.
  TextTheme get textTheme => theme.textTheme;

  /// - [colorScheme]: Retrieves the `ColorScheme` of the current theme, providing access to colors.
  ColorScheme get colorScheme => theme.colorScheme;

 


  /// Navigates to the login page using a named route.
  void goToLoginPage() => GoRouter.of(this).goNamed(AppRoutes.login);

  /// Navigates to the signup page using a named route.
  void goToSignUpPage() => GoRouter.of(this).goNamed(AppRoutes.signup);


}
