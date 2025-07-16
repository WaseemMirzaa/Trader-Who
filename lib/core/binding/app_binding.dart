part of 'binding.dart';

/// The [AppRouter] class sets up the navigation system for the app using GetX.
// core/bindings/app_bindings.dart

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    // Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    // Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Use put instead of lazyPut to ensure immediate initialization
    Get.put<SplashController>(SplashController(), permanent: true);
  }
}

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}

class NewAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewAccountController>(() => NewAccountController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageController>(() => HomepageController());
    Get.lazyPut<UserController>(() => UserController());
  }
}

class JobPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobController>(() => JobController());
  }
}

class TradesPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeRateController>(() => TradeRateController());
  }
}

class TradesLargerJoBPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeRateLargeJobController>(() => TradeRateLargeJobController());
  }
}

class JobHistoryPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobHistoryPageController>(() => JobHistoryPageController());
  }
}

class ChatPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}

class NotificationPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

class ProfilePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

class MyAccountPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyaccountController>(() => MyaccountController());
  }
}

class TradeHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeHomeController>(() => TradeHomeController());
  }
}

class TradeJobHistoryPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeJobHistoryController>(() => TradeJobHistoryController());
  }
}

class MainPageWithNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainPageWithNavBarController>(
      () => MainPageWithNavBarController(),
    );
    // Add controllers for all pages accessible through navigation
    // Customer pages controllers
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<HomepageController>(() => HomepageController());
    Get.lazyPut<JobHistoryPageController>(() => JobHistoryPageController());
    Get.lazyPut<ChatController>(() => ChatController());

    // Trade pages controllers
    Get.lazyPut<TradeHomeController>(() => TradeHomeController());
    Get.lazyPut<TradeJobHistoryController>(() => TradeJobHistoryController());
    Get.lazyPut<TradeChatController>(() => TradeChatController());
    Get.lazyPut<TradeProfileController>(() => TradeProfileController());
  }
}

class TradeContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeContainerController>(() => TradeContainerController());
  }
}

class TradeNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeNotificationController>(
      () => TradeNotificationController(),
    );
  }
}

class TradeChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeChatController>(() => TradeChatController());
  }
}

class TradeProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeProfileController>(() => TradeProfileController());
  }
}

class TradeMyAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeMyaccountController>(() => TradeMyaccountController());
  }
}

class TradeCustomerFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeCustomerFeedbackController>(
      () => TradeCustomerFeedbackController(),
    );
  }
}

class TradeRateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeRateController>(() => TradeRateController());
  }
}

class TradeServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeServiceController>(() => TradeServiceController());
  }
}

class TradeServiceSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeServiceSignupController>(
      () => TradeServiceSignupController(),
    );
  }
}

class TradeShortPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeShortPageController>(() => TradeShortPageController());
  }
}

class CustomJobPostPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomJobPostController>(() => CustomJobPostController());
  }
}

class ChangePasswordPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}

class VerificationEmailPageBinding extends Bindings {
  @override
  void dependencies() {
    // Retrieve arguments from Get.arguments
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      throw Exception(
        'Required arguments for EmailVerificationController are missing',
      );
    }

    final String userEmail = arguments['email'] as String;
    final UserModel userModel = arguments['userModel'] as UserModel;
    final String userId = arguments['userId'] as String;
    final bool isTradesperson = arguments['isTradesperson'] as bool;

    // Instantiate the controller with the required arguments
    Get.lazyPut<EmailVerificationController>(
      () => EmailVerificationController(
        userEmail: userEmail,
        userModel: userModel,
        userId: userId,
        isTradesperson: isTradesperson,
      ),
    );
  }
}
