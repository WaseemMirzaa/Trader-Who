part of 'config.dart';

/// The [AppRouter] class sets up the navigation system for the app by initializing
/// a [GoRouter] instance.


/// The [AppRouter] class sets up the navigation system for the app using GetX.
class AppRouter {
  /// Returns a list of [GetPage] for GetX navigation.
  List<GetPage> get getPages => [
        GetPage(
          name: AppRoutes.root,
          page: () => const SplashPage(),
          binding: SplashBinding(), // Inject SplashController
        ),
        // GetPage(
        //   name: AppRoutes.login,
        //   page: () => const LoginPage(),
        //   binding: LoginBinding(), // Inject LoginController
        // ),
        // GetPage(
        //   name: AppRoutes.signup,
        //   page: () => const SignUpPage(),
        //   binding: SignUpBinding(), // Inject SignUpController
        // ),
      ];
}