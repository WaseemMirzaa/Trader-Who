import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/config/config.dart';
import '../core/cubit/theme_cubit.dart';
import '../core/di/di.dart';

import '../core/theme/app_color.dart';
import '../core/utils/size_utils.dart';

/// The main application widget that sets up the Flutter app with state management,
/// notifications, themes, and routing.
class App extends StatefulWidget {
  /// Creates an instance of the [App] widget.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AuthCubit>(create: (BuildContext context) => AuthCubit()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          return SizerUtils(
            builder: (BuildContext context, Orientation orientation) {
              return MaterialApp.router(
                title: 'My App',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode:
                    theme == AppTheme.light ? ThemeMode.light : ThemeMode.dark,
                debugShowCheckedModeBanner: false,
                routerConfig: sl<AppRouter>().router,
              );
            },
          );
        },
      ),
    );
  }
}