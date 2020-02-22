/// Adds [except] functionality
extension ExceptIterator<K> on Iterable<K> {
  /// Fires [onDifference] if [K] is not found in [keys]
  void except(Iterable<K> keys, void onDifference(K entry)) {
    forEach((entry) {
      if (!keys.contains(entry)) {
        onDifference(entry);
      }
    });
  }
}
