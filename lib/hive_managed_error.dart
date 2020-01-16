class HiveManagedError extends Error {
  final message;

  HiveManagedError(this.message);

  @override
  String toString() => 'Hive Manged: $message';
}
