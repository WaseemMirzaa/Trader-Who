// app.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traderou/controller/navigation_controller.dart';
import 'package:traderou/core/binding/binding.dart';
import 'package:traderou/core/config/config.dart';

import 'core/config/app_routes.dart';
import 'core/theme/app_color.dart';
import 'core/utils/size_utils.dart';

/// The main application widget that sets up the Flutter app with GetX.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize global bindings
    AppBinding().dependencies();
    Get.put(NavigationController());
    return SizerUtils(
      builder: (BuildContext context, Orientation orientation) {
        return GetMaterialApp(
          title: 'Traderou',
          theme: lightTheme,
          darkTheme: darkTheme,

          debugShowCheckedModeBanner: false,

          getPages: AppRouter().getPages,
          initialRoute: AppRoutes.root,
        );
      },
    );
  }
}
