extension IntersectableIterator<K> on Iterable<K> {
  void intersect(Iterable<K> keys, void onDifference(K entry)) {
    forEach((entry) {
      if (!keys.contains(entry)) {
        onDifference(entry);
      }
    });
  }
}
