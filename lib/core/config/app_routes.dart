/// The [AppRoutes] class provides a single source of truth for all route
/// strings used with the app's navigation system. This approach helps prevent
/// typos, makes refactoring easier, and promotes consistency across the app.
class AppRoutes {
  AppRoutes._();

  /// Root
  static const String root = '/';

   /// The onboarding screen route.
  static const String onboarding = '/onboarding';

  /// The login screen route.
  static const String login = '/login';

  /// The login screen route.
  static const String newAccount = '/newaccount';

  /// The signup screen route.
  static const String signup = '/signup';

  /// The home screen route.
  static const String homePage = '/homepage';

   /// The job screen route.
  static const String jobPage = '/jobpage';

     /// The trades screen route.
  static const String tradesPage = '/tradespage';

       /// The job history screen route.
  static const String jobHistoryPage = '/jobhistorypage';

  
}
