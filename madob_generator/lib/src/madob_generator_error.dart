/// MadobGenerator related errors
class MadobGeneratorError extends Error {
  /// Contains a description of the error
  final String message;

  /// Initialize an error with a message
  MadobGeneratorError(this.message);

  @override
  String toString() => 'MadobGenerator: $message';
}
