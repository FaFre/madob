/// Madob related errors
class MadobError extends Error {
  /// Contains a description of the error
  final String message;

  /// Initialize error with a message
  MadobError(this.message);

  @override
  String toString() => 'Madob: $message';
}
