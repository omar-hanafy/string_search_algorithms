/// Base exception for the package.
class StringSearchAlgorithmsException implements Exception {
  /// Creates a [StringSearchAlgorithmsException].
  StringSearchAlgorithmsException(this.message, [this.details]);

  /// The error message.
  final String message;

  /// Additional details about the error (optional).
  final Object? details;

  @override
  String toString() =>
      details == null ? message : '$message (details: $details)';
}

/// Thrown when options/configuration are invalid.
class InvalidConfigurationException extends StringSearchAlgorithmsException {
  /// Creates an [InvalidConfigurationException].
  InvalidConfigurationException(super.message, [super.details]);
}

/// Thrown when a required input is invalid (e.g., empty pattern for compile).
class InvalidInputException extends StringSearchAlgorithmsException {
  /// Creates an [InvalidInputException].
  InvalidInputException(super.message, [super.details]);
}

/// Thrown when an algorithm is not supported/registered.
class AlgorithmNotSupportedException extends StringSearchAlgorithmsException {
  /// Creates an [AlgorithmNotSupportedException].
  AlgorithmNotSupportedException(super.message, [super.details]);
}
