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
      page: () {
        final args = Get.arguments;
        // Handle both old string format and new map format
        final selectedCategory =
            args is Map
                ? (args['categoryName'] ?? args['categoryId'] ?? '')
                : (args ?? '');
        return JobPage(selectedCategory: selectedCategory);
      },
      binding: JobPageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradesPage,
      page: () => const TradesPage(),
      binding: TradesPageBinding(),
    ),
    GetPage(
      name: AppRoutes.tradeLargeJobServices,
      page: () => const TradeLargerRatePage(),
      binding: TradesLargerJoBPageBinding(),
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
      name: AppRoutes.tradeShortPage,
      page: () => const TradeShortServicesPage(),
      binding: TradeServiceSignupBinding(),
    ),
    GetPage(
      name: AppRoutes.customJobPost,
      page: () => CustomJobPost(),
      binding: CustomJobPostPageBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordPage(),
      binding: ChangePasswordPageBinding(),
    ),

    GetPage(
      name: AppRoutes.emailVerification,
      page: () => EmailVerificationScreen(),
      binding: VerificationEmailPageBinding(),
    ),
  ];
}
