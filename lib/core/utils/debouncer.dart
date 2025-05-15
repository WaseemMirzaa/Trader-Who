import 'dart:async';
import 'dart:ui';

/// A utility class for debouncing function calls, ensuring that an action is only
/// executed after a specified delay, canceling any previous pending actions.
class Debouncer {
  /// The delay in milliseconds before the action is executed.
  final int milliseconds;

  /// The action to be executed after the debounce period.
  VoidCallback? action;

  /// Internal timer to manage the debounce delay.
  Timer? _timer;

  /// Creates a [Debouncer] with the specified [milliseconds] delay.
  Debouncer({required this.milliseconds});

  /// Schedules the [action] to run after the [milliseconds] delay.
  ///
  /// If a previous action is pending, it is canceled before scheduling the new one.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
