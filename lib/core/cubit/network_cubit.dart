import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/network.dart';

/// Represents the network connection status.
enum NetworkStatus {
  ///network is connected.
  connected,

  /// network is disconnected.
  disconnected,
}

/// A [Cubit] that manages the network connection status.
///
/// The [NetworkCubit] listens for changes in network connectivity and updates
/// its state accordingly. It also provides a method to check the initial
/// network connection status when the app starts.
class NetworkCubit extends Cubit<NetworkStatus> {
  /// An instance of [NetworkInfo] used to check and listen for network changes.
  final NetworkInfo _networkInfo;

  /// Creates an instance of [NetworkCubit] with the given [NetworkInfo].
  ///
  /// Initializes the cubit with a [NetworkStatus.disconnected] state and starts
  /// listening for network connection changes.
  NetworkCubit(this._networkInfo) : super(NetworkStatus.disconnected) {
    _initialize();
  }

  /// Sets up a listener to monitor network connection changes.
  ///
  /// Emits [NetworkStatus.connected] if the device is connected to the network
  /// and [NetworkStatus.disconnected] otherwise.
  void _initialize() {
    _networkInfo.simpleConnectionChecker.onConnectionChange.listen((
      bool connected,
    ) {
      if (connected) {
        emit(NetworkStatus.connected);
      } else {
        emit(NetworkStatus.disconnected);
      }
    });
  }

  /// Checks the initial network connection status.
  ///
  /// This method is typically called when the app starts to determine the
  /// initial connectivity state. Emits [NetworkStatus.connected] if the device
  /// is connected to the network and [NetworkStatus.disconnected] otherwise.
  Future<void> checkInitialConnection() async {
    final bool isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      emit(NetworkStatus.connected);
    } else {
      emit(NetworkStatus.disconnected);
    }
  }
}
