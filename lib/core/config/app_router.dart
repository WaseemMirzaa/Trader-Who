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
        GetPage(
          name: AppRoutes.onboarding,
          page: () => const OnBoardingPage(),
          binding: OnBoardingBinding(), // Inject OnBoardingController
        ),
       GetPage(
          name: AppRoutes.newAccount,
          page: () => const NewAccountPage (),
          binding: NewAccountBinding(), // Inject new accountController
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginPage(),
          binding: LoginBinding(), // Inject LoginController
        ),
        GetPage(
          name: AppRoutes.signup,
          page: () => const SignupPage(),
          binding: SignUpBinding(), // Inject LoginController
        ),
         GetPage(
          name: AppRoutes.homePage,
          page: () => const HomePage(),
          binding: HomePageBinding(), // Inject LoginController
        ),
      ];
}