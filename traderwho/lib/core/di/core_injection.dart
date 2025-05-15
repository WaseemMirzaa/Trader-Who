part of 'di.dart';

/// Service Locator
final GetIt sl = GetIt.instance;

/// Dependency Injection
Future<void> initDI() async {
  await Hive.initFlutter();
  final box = await Hive.openBox('preferencesBox');
  sl.registerLazySingleton<Box<dynamic>>(() => box);
  sl.registerLazySingleton<PreferencesUtil>(
    () => PreferencesUtil(sl<Box<dynamic>>()),
  );
  // Network connection Checker.
  final SimpleConnectionChecker connectionChecker =
      SimpleConnectionChecker()..setLookUpAddress('pub.dev');
  sl.registerLazySingleton<SimpleConnectionChecker>(() => connectionChecker);

  final Dio dio = Dio();
  final BaseOptions baseOptions = BaseOptions(
    receiveTimeout: const Duration(milliseconds: 30000),
    connectTimeout: const Duration(milliseconds: 30000),
    contentType: 'application/json',
    headers: <String, String>{'Content-Type': 'application/json'},
    maxRedirects: 2,
  );

  dio.options = baseOptions;

  dio.interceptors.clear();
  final DioFirebasePerformanceInterceptor performanceInterceptor =
      DioFirebasePerformanceInterceptor();


  // sl.registerLazySingleton<NotificationServices>(NotificationServices.new);

  // sl.registerLazySingleton<FirebaseCrashlytics>(
  //   () => FirebaseCrashlytics.instance,
  // );

  // sl.registerLazySingleton<CrashlyticsService>(
  //   () => CrashlyticsService(
  //     crashlytics: sl<FirebaseCrashlytics>(),
  //     loggerUtils: sl<LoggerUtils>(),
  //   ),
  // );

  // sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);

  // sl.registerLazySingleton<AnalyticsService>(
  //   () => AnalyticsService(
  //     analytics: sl<FirebaseAnalytics>(),
  //     loggerUtils: sl<LoggerUtils>(),
  //   ),
  // );

  dio.interceptors.add(performanceInterceptor);
  sl.registerLazySingleton(() => dio);

  // sl.registerLazySingleton<LoggerUtils>(() => LoggerUtils(Logger()));

  sl.registerFactory(() => NetworkCubit(sl<NetworkInfo>()));

  // // Network Client.
  // sl.registerLazySingleton(() => NetworkClient(dio: sl()));

  sl.registerSingleton<AppRouter>(AppRouter());

  // sl.registerLazySingleton<DioInterceptor>(
  //   () => DioInterceptor(dio, sl<PreferencesUtil>()),
  // );
  // dio.interceptors.add(sl<DioInterceptor>());
  // Local Cache
  sl.registerLazySingleton<NetworkInfoImpl>(NetworkInfoImpl.new);
}
