/// HiveManaged related errors
class HiveManagedError extends Error {
  /// Contains a description of the error
  final String message;

  /// Initialize error with a message
  HiveManagedError(this.message);

  @override
  String toString() => 'HiveManaged: $message';
}
