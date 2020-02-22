/// Adds [capitalize] functionality
extension StringCapitalize on String {
  /// Returns an capitalized [String]
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
