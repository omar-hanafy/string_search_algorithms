/// Base exception for the package.
class StringSearchAlgorithmsException implements Exception {
  StringSearchAlgorithmsException(this.message, [this.details]);

  final String message;
  final Object? details;

  @override
  String toString() =>
      details == null ? message : '$message (details: $details)';
}

/// Thrown when options/configuration are invalid.
class InvalidConfigurationException extends StringSearchAlgorithmsException {
  InvalidConfigurationException(super.message, [super.details]);
}

/// Thrown when a required input is invalid (e.g., empty pattern for compile).
class InvalidInputException extends StringSearchAlgorithmsException {
  InvalidInputException(super.message, [super.details]);
}

/// Thrown when an algorithm is not supported/registered.
class AlgorithmNotSupportedException extends StringSearchAlgorithmsException {
  AlgorithmNotSupportedException(super.message, [super.details]);
}
  