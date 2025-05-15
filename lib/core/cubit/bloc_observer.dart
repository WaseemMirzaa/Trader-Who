import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
/// The `CubitObserver` extends the `BlocObserver` class and overrides the 
/// `onChange` method to log state changes of all `Cubit` instances in the 
/// application. This can be useful for debugging and monitoring the flow 
/// of state changes during the app lifecycle.
class CubitObserver extends BlocObserver {
  @override
    /// - [bloc]: The `Cubit` instance that triggered the state change.
  /// - [change]: The `Change` object representing the state transition.
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    log('CubitObserver onChange: (${bloc.runtimeType}, $change)');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('CubitObserver onError: (${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
