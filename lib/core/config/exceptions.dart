// Define the AttackType enum
part of 'config.dart';

/// An enum that represents various types of attacks.
///
/// This enum defines different types of cybersecurity attacks that
/// can be detected in the system.
enum AttackType {
  /// Represents an attempt to inject malicious code, such as SQL injection.
  injectionAttempt,

  /// Represents a brute force attack, where multiple attempts are made to gain unauthorized access.
  bruteForce,

  /// Represents a phishing attack, where attackers attempt to trick users into revealing sensitive information.
  phishing,

  /// Represents a malware attack, involving malicious software that harms the system.
  malware,

  /// Represents an unknown or unclassified attack type.
  unknown,
}

/// A [CustomException] class that implements the [Exception] interface.
///
/// This class represents a [CustomException] that can be thrown and caught in the application.
/// It contains a [message] field to store the error message, and a method to convert the exception
/// into an iterable for easier logging or serialization.
abstract class CustomException implements Exception {
  /// The key used to represent the [message] in the iterable.
  static const String messageKey = 'message';

  /// The message associated with the exception.
  final String message;

  /// Constructs a [CustomException] with the given [message].
  ///
  /// The [message] is required to describe the error or exception.
  CustomException({required this.message});

  @override
  String toString() => 'CustomException: $message';

  /// Converts the exception to an [Iterable].
  ///
  /// This method returns an [Iterable] containing the key-value pair
  /// where the key is [messageKey] and the value is the exception message.
  Iterable<Object> toIterable() => <Object>['$messageKey: $message'];
}

/// A custom exception class that extends [CustomException] to handle network-related errors.
///
/// This [NetworkException] is used when a network request fails or encounters an error. It stores details
/// about the network request, such as the URL and status code (if available), in addition to the error message.
class NetworkException extends CustomException {
  /// The details of the network request that caused the exception.
  final RequestOptions requestOptions;

  /// The HTTP status code returned by the request (optional).
  final int? statusCode;

  /// Constructs a [NetworkException] with the given [message], [requestOptions], and optional [statusCode].
  NetworkException({
    required super.message,
    required this.requestOptions,
    this.statusCode,
  });

  @override
  String toString() =>
      'NetworkException: $message [URL: ${requestOptions.uri}]'
      '${statusCode != null ? ' [StatusCode: $statusCode]' : ''}';

  @override
  Iterable<Object> toIterable() => <Object>[
    super.toIterable(),
    'url: ${requestOptions.uri}',
    if (statusCode != null) 'statusCode: $statusCode',
  ];
}

/// A [FirebaseCustomException] class that extends [CustomException] to handle Firebase-related errors.
///
/// This exception is used when an error occurs during a Firebase operation. It contains the error message
/// as well as a specific error code to help identify the type of error.
class FirebaseCustomException extends CustomException {
  /// This constant key is used in the [toIterable] method to represent the error code field
  /// when serializing the exception. It helps to maintain consistency and ensure the correct
  /// key name is used when logging or processing the exception's data.
  static const String codeKey = 'code';

  /// The specific error code associated with the Firebase error.
  final String code;

  /// Constructs a [FirebaseCustomException] with the given [message] and [code].
  ///
  /// The [message] describes the error, and the [code] provides a specific error code
  /// that helps identify the type of Firebase error (e.g., `network_error`, `permission_denied`).
  FirebaseCustomException({required super.message, required this.code});

  @override
  String toString() => 'FirebaseCustomException: [Code: $code] $message';

  @override
  Iterable<Object> toIterable() => <Object>[
    super.toIterable(),
    '$codeKey: $code',
  ];
}

/// A [GeneralException] class that extends [CustomException].
///
/// This exception is used for handling general errors that don't fit into more specific exception categories.
/// It provides a custom error message that can be used for debugging or logging.
class GeneralException extends CustomException {
  /// Creates an instance of [GeneralException] with a custom error message.
  ///
  /// The [message] parameter is required and should provide a description of the er
  GeneralException({required super.message});

  @override
  String toString() => 'GeneralException: $message';
}

///  A [SecurityException] class that extends [CustomException].
///
/// This exception represents security issues such as attack attempts. It includes information about
/// the type of attack, context surrounding the attack, and the timestamp of the error.
class SecurityException extends CustomException {
  /// [payloadKey] used for accessing the payload data in the exception's context.
  static const String payloadKey = 'payload';

  /// [timestampKey] used for accessing the timestamp of the exception.
  static const String timestampKey = 'timestamp';

  /// [contextKey] used for accessing the context details in the exception's context.
  static const String contextKey = 'context';

  /// [attackTypeKey] used for accessing the type of attack in the exception.
  static const String attackTypeKey = 'attackType';

  /// This field will indicate what kind of security threat was detected (e.g., SQL injection, phishing).
  final AttackType attackType;

  /// This is an optional field and may contain specific details about the attack (e.g., the injected payload).
  final Map<String, dynamic>? context;

  /// This field is automatically set to the current time when the exception is instantiated.
  final DateTime timestamp;

  /// Creates a new instance of [SecurityException].
  ///
  /// The [message] provides a description of the error, while the [attackType] indicates the type of attack.
  /// The optional [context] allows for including additional information about the attack, such as malicious data.
  /// The [timestamp] is automatically set to the current date and time.
  SecurityException({
    required super.message,
    required this.attackType,
    this.context,
  }) : timestamp = DateTime.now();

  @override
  String toString() =>
      'SecurityException: [${attackType.name}] $message (${timestamp.toIso8601String()})';

  /// Factory constructor to create a [SecurityException] specifically for an injection attempt attack.
  ///
  /// The [message] parameter provides a description of the attack, and [payload] is the malicious code
  /// or data involved in the injection attempt.
  factory SecurityException.injectionAttempt({
    required String message,
    required String payload,
  }) {
    return SecurityException(
      message: message,
      attackType: AttackType.injectionAttempt,
      context: <String, dynamic>{payloadKey: payload},
    );
  }

  @override
  Iterable<Object> toIterable() => <Object>[
    super.toIterable(),
    '$attackTypeKey: ${attackType.name}',
    '$timestampKey: ${timestamp.toIso8601String()}',
    if (context != null)
      '$contextKey: ${context!.entries.map((MapEntry<String, dynamic> e) => '${e.key}: ${e.value}')}',
  ];
}
