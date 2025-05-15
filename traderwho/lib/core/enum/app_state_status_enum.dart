/// Generic enum for all state classes
enum AppStateStatus {
  /// The initial state of the app.
  initial,

  /// The app is currently loading data.
  loading,

  /// The app has successfully loaded data.
  success,

  /// The app has encountered an error while loading data.
  /// The error message is passed as a parameter.
  failure,

  /// The app is currently refreshing data.
  delete,
}
