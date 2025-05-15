part of 'mixins.dart';

/// A mixin that provides exception handling functionality.
mixin ExceptionMixin {
  static const String _tag = 'ExceptionMixin';

  Future<CustomException> _mapException(Object e, [StackTrace? stack]) async {
    // await sl<CrashlyticsService>().recordError(
    //   e,
    //   stack,
    //   fatal: true,
    //   reason: e is CustomException ? e.message : e.runtimeType.toString(),
    //   information: e is CustomException ? e.toIterable() : <Object>[],
    // );

    return switch (e) {
      NetworkException() => e,
      GeneralException() => e,
      SecurityException() => e,
      FirebaseException() => FirebaseCustomException(
        message: e.message ?? 'defaultErrorMsg',
        code: e.code,
      ),
      _ => GeneralException(message: e.toString()),
    };
  }

  /// Checks internet connectivity
  Future<void> _checkConnectivity() async {
    if (!await sl<NetworkInfoImpl>().isConnected) {
      throw GeneralException(message: 'No Internet Connection');
    }
  }

  /// Perform the provided action and handles exceptions
  Future<Either<CustomException, T>> handleFuture<T>(
    Future<T> Function() action,
  ) async {
    try {
      await _checkConnectivity();

      return right(await action());
    } on Exception catch (e, stack) {
      final CustomException exception = await _mapException(e, stack);
     
      return left(exception);
    }
  }
}
