part of 'binding.dart';
/// The [AppRouter] class sets up the navigation system for the app using GetX.
// core/bindings/app_bindings.dart



class AppBinding extends Bindings {
  @override
  void dependencies() {
    
    // Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    // Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
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