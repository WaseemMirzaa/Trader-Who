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
      page: () {
        // Get the arguments passed from navigation
        final args =
            Get.arguments ?? false; // Default to false (customer) if no args
        return SignupPage(isTradesperson: args);
      },
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
    GetPage(
      name: AppRoutes.myAccountPage,
      page: () => MyAccountPage(),
      binding: MyAccountPageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradesHomePage,
      page: () => TradeHomePage(),
      binding: TradeHomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradesJobHistoryPage,
      page: () => TradesJobHistoryPage(),
      binding: TradeJobHistoryPageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradesChatPage,
      page: () => TradeHomePage(),
      binding: TradeHomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradesProfilePage,
      page: () => TradeHomePage(),
      binding: TradeHomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.mainPageWithNavBar,
      page: () => MainPageWithNavbar(),
      binding: MainPageWithNavBarBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeContainer,
      page: () => TradeContainer(),
      binding: TradeContainerBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeNotification,
      page: () => TradeNotificationPage(),
      binding: TradeNotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeChat,
      page: () => TradeChatPage(),
      binding: TradeChatBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeProfile,
      page: () => TradeProfilePage(),
      binding: TradeProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeMyaccount,
      page: () => TradeMyaccountPage(),
      binding: TradeMyAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeCustomerFeedback,
      page: () => TradeCustomerFeedbackPage(),
      binding: TradeCustomerFeedbackBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeRate,
      page: () => TradeRatePage(),
      binding: TradeRateBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeServices,
      page: () => TradeServicesPage(),
      binding: TradeServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeServicesSignup,
      page: () => TradeServiceSignupPage(),
      binding: TradeServiceSignupBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeServiceSignupPage,
      page: () => const TradeServiceSignupPage(),
    ),
  ];
}
