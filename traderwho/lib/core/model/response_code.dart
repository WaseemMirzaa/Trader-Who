///ResponseCode is used to handle the response code from the API.
enum ResponseCode {
  /// The request was successful and a resource was created.
  ///
  /// Corresponds to HTTP status code **201 Created**.
  success(201),

  /// The request was successful and the resource was deleted.
  ///
  /// Corresponds to HTTP status code **204 No Content**.
  delete(204),

  /// The request was unauthorized, possibly due to invalid credentials.
  ///
  /// Corresponds to HTTP status code **401 Unauthorized**.
  error(401),

  /// The requested resource could not be found.
  ///
  /// Corresponds to HTTP status code **404 Not Found**.
  warning(404),

  /// The server encountered an internal error.
  ///
  /// Corresponds to HTTP status code **500 Internal Server Error**.
  systemError(500),

  /// The request could not be completed due to a conflict with the current state.
  ///
  /// Corresponds to HTTP status code **409 Conflict**.
  conflict(409),

  /// The request was malformed or invalid.
  ///
  /// Corresponds to HTTP status code **400 Bad Request**.
  badRequest(400);

  /// The actual HTTP status code associated with this enum value.

  final int value;
  const ResponseCode(this.value);

  /// Converts an integer value to a ResponseCode enum value.
  static ResponseCode fromValue(int value) {
    switch (value) {
      case 200:
        return ResponseCode.success;
      case 204:
        return ResponseCode.delete;
      case 201:
        return ResponseCode.success;
      case 400:
        return ResponseCode.badRequest;
      case 409:
        return ResponseCode.conflict;
      case 401:
        return ResponseCode.error;
      case 404:
        return ResponseCode.warning;
      case 500:
        return ResponseCode.systemError;
      default:
        throw ArgumentError(
          'Invalid value, if this is 0 then a new API needs to be created',
        );
    }
  }
}
