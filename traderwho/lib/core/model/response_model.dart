import 'response_code.dart';

/// This is a base class for all response models in the application.
class ResponseModelBase {
  /// The message returned from the server.
  final String message;

  /// The status code of the response.
  final ResponseCode status;

  /// The constructor for the base response model.
  ResponseModelBase({required this.message, required this.status});
}

/// This is a generic response model that extends the base response model.
class ResponseModel<T> extends ResponseModelBase {
  /// The data returned from the server.
  T? data;

  /// The constructor for the generic response model.
  ResponseModel({required super.message, required super.status, this.data});
}
