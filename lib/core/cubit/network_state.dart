import 'package:equatable/equatable.dart';
/// An abstract base class representing the state of network operations.
///
/// The [NetworkState] class is used as a base class for defining various 
/// states that a network operation can have, such as loading, success, 
/// or error. It extends `Equatable` to enable easy comparison of states 
/// in the application.
abstract class NetworkState extends Equatable {
  /// A message associated with the [NetworkState].
  ///
  /// This getter can be used to provide additional context or 
  /// information about the current network state, such as an error 
  /// message or a success message.

  String get message;
}
/// The [NetworkConnectedState] is a concrete implementation of the 
/// [NetworkState] class, indicating that the application is connected 
/// to the internet. It provides a message to describe the state.
class NetworkConnectedState extends NetworkState {
  @override
  List<Object?> get props => <Object?>[];

  @override
  String get message => 'Internet connected';
}
/// The [NetworkInitialState] class is a concrete implementation of 
/// the [NetworkState] class. It indicates that the network status is 
/// currently being checked or is in an uninitialized state.
class NetworkInitialState extends NetworkState {
  @override
  List<Object?> get props => <Object?>[];

  @override
  String get message => 'Checking internet connection';
}
/// The [NetworkDisConnectedState] class is a concrete implementation of 
/// the [NetworkState] class, indicating that the application is currently 
/// not connected to the internet. It provides a message to describe the state.
class NetworkDisConnectedState extends NetworkState {
  @override
  List<Object?> get props => <Object?>[];

  @override
  String get message => 'Inernet is not connected';
}
