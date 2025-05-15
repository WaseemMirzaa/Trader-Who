part of 'network.dart';

/// An abstract contract for checking network connectivity.
///
/// [NetworkInfo] defines a platform-agnostic interface for determining whether
/// the device is currently connected to the internet.
abstract class NetworkInfo {
  /// Returns a [Future] that resolves to `true` if the device is connected to the internet.
  Future<bool> get isConnected;

  /// Provides access to a [SimpleConnectionChecker] instance
  /// for performing detailed or manual network checks.
  SimpleConnectionChecker get simpleConnectionChecker;
}

/// The concrete implementation of [NetworkInfo] using [SimpleConnectionChecker].
///
/// - On web platforms (`kIsWeb`), it always returns `true` for connectivity.
/// - On mobile or desktop platforms, it uses [SimpleConnectionChecker]
///   to determine internet connectivity.
class NetworkInfoImpl extends NetworkInfo {
  /// Creates an instance of [NetworkInfoImpl].
  NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      return true;
    } else {
      return await SimpleConnectionChecker.isConnectedToInternet();
    }
  }

  @override
  SimpleConnectionChecker get simpleConnectionChecker =>
      SimpleConnectionChecker();
}
