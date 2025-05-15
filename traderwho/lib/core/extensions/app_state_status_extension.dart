// Extension for state checking
import '../enum/app_state_status_enum.dart';

/// Extension for AppStateStatus
extension AppStateStatusX on AppStateStatus {
  /// Check if the current state is initial.
  bool get isInitial => this == AppStateStatus.initial;

  /// Check if the current state is loading.
  bool get isLoading => this == AppStateStatus.loading;

  /// Check if the current state is success.
  bool get isSuccess => this == AppStateStatus.success;

  /// Check if the current state is failure.
  bool get isFailure => this == AppStateStatus.failure;

  /// Check if the current state is empty.
  bool get isDelete => this == AppStateStatus.delete;
}
