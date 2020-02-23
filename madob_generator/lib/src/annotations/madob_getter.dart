import 'package:hive/hive.dart';

/// Annotate a getter with [MadobGetter] to add it to the managed object
/// It's inherited from [HiveField]
class MadobGetter extends HiveField {
  /// Adds an getter with corresponding [index]
  const MadobGetter(int index) : super(index);
}
