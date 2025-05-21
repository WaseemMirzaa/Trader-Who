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
  }
}

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageController>(() => HomepageController());
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
    Get.lazyPut<JobController>(() => JobController());
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
