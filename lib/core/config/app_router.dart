part of 'config.dart';

class AppRouter {
  List<GetPage> get getPages => [
    GetPage(
      name: AppRoutes.root,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnBoardingPage(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: AppRoutes.newAccount,
      page: () => const NewAccountPage(),
      binding: NewAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.jobPage,
      page: () => const JobPage(),
      binding: JobPageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradesPage,
      page: () => const TradesPage(),
      binding: TradesPageBinding(),
    ),
    GetPage(
      name: AppRoutes.jobHistoryPage,
      page: () => const JobHistoryPage(),
      binding: JobHistoryPageBinding(),
    ),
    GetPage(
      name: AppRoutes.chatPage,
      page: () => ChatPage(),
      binding: ChatPageBinding(),
    ),
    GetPage(
      name: AppRoutes.notificationPage,
      page: () => NotificationPage(),
      binding: NotificationPageBinding(),
    ),
    GetPage(
      name: AppRoutes.profilePage,
      page: () => ProfileScreen(),
      binding: ProfilePageBinding(),
    ),
  ];
}
