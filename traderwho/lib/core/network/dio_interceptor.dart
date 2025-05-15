// part of 'network.dart';

// class DioInterceptor extends Interceptor {
//   final Dio dio;
//   final PreferencesUtil preferencesUtil;

//   DioInterceptor(this.dio, this.preferencesUtil);

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final String? token =
//         preferencesUtil.getPreferencesData(accessToken) as String?;
//     debugPrint('DioInterceptor: Token retrieved: $token');
//     if (token != null && token.isNotEmpty) {
//       options.headers['Authorization'] = 'Bearer $token';
//       debugPrint('DioInterceptor: Added Authorization: Bearer $token');
//     } else {
//       debugPrint('DioInterceptor: No token found or token is empty');
//     }
//     super.onRequest(options, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
//       if (await _refreshToken()) {
//         try {
//           final Response response = await _retry(err.requestOptions);
//           return handler.resolve(response);
//         } on Exception catch (e) {
//           debugPrint('$e');
//           return handler.reject(err);
//         }
//       } else {
//         _handleLogout();
//         return handler.reject(err);
//       }
//     }
//     super.onError(err, handler);
//   }

//   Future<bool> _refreshToken() async {
//     try {
//       final String? refreshTokenValue =
//           preferencesUtil.getPreferencesData(refreshToken) as String?;
//       if (refreshTokenValue == null || refreshTokenValue.isEmpty) return false;

//       final NetworkClient networkClient = GetIt.I<NetworkClient>();
//       final response = await networkClient.invoke(
//         AppConfig.baseUrl,
//         RequestType.post,
//         requestBody: {refreshToken: refreshTokenValue},
//       );

//       if (response.statusCode == 200) {
//         final newAccessToken = response.data[accessToken] as String;
//         final newRefreshToken = response.data[refreshToken] as String?;

//         await saveTokens(newAccessToken, newRefreshToken);
//         return true;
//       }
//       return false;
//     } on Exception catch (e) {
//       debugPrint('$e');
//       return false;
//     }
//   }

//   Future<void> saveTokens(
//     String accessTokenValue,
//     String? refreshTokenValue,
//   ) async {
//     await preferencesUtil.setPreferencesData(accessToken, accessTokenValue);
//     if (refreshTokenValue != null && refreshTokenValue.isNotEmpty) {
//       await preferencesUtil.setPreferencesData(refreshToken, refreshTokenValue);
//     }
//   }

//   Future<Response> _retry(RequestOptions requestOptions) async {
//     final String? token =
//         preferencesUtil.getPreferencesData(accessToken) as String?;
//     requestOptions.headers['Authorization'] = 'Bearer $token';
//     return dio.request(
//       requestOptions.path,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//       options: Options(
//         method: requestOptions.method,
//         headers: requestOptions.headers,
//       ),
//     );
//   }

//   void _handleLogout() {
//     preferencesUtil.clearPreferencesData(accessToken);
//     preferencesUtil.clearPreferencesData(refreshToken);
//     preferencesUtil.clearPreferencesData(userData);
//   }

//   Future<void> setTokensFromLogin(
//     String accessTokenValue,
//     String refreshTokenValue,
//   ) async {
//     await saveTokens(accessTokenValue, refreshTokenValue);
//   }

//   Future<void> clearTokens() async {
//     await preferencesUtil.clearPreferencesData(accessToken);
//     await preferencesUtil.clearPreferencesData(refreshToken);
//   }
// }
