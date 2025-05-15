part of 'config.dart';

/// The [AppRouter] class sets up the navigation system for the app by initializing
/// a [GoRouter] instance.
class AppRouter {
  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldMessengerState> _snackBarKey =
      GlobalKey<ScaffoldMessengerState>();
  late final GoRouter _router;

  /// Creates an instance of [AppRouter] with an optional [navigatorKey].
  AppRouter({GlobalKey<NavigatorState>? navigatorKey})
    : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _router = GoRouter(
      debugLogDiagnostics: kDebugMode,
      navigatorKey: _navigatorKey,
      initialLocation: AppRoutes.root,
      redirect: (BuildContext context, GoRouterState state) async {
        return null;
      },
      routes: _routes,
    );
  }

  /// Public getter to access the configured [GoRouter] instance.
  GoRouter get router => _router;

  List<RouteBase> get _routes => <RouteBase>[
    GoRoute(
      path: AppRoutes.root,
      name: AppRoutes.root,
      // builder: (BuildContext context, GoRouterState state) {
      //   // sl<AnalyticsService>().logScreenView(screenName: 'Splash Screen');
      //   return const SplashPage();
      // },
    ),
    // GoRoute(
    //   name: AppRoutes.login,
    //   path: AppRoutes.login,
    //   builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    // ),
    // GoRoute(
    //   name: AppRoutes.signup,
    //   path: AppRoutes.signup,
    //   builder:
    //       (BuildContext context, GoRouterState state) => const SignUpPage(),
    // ),
  ];
}
