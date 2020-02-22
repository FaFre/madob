import 'package:hive/hive.dart';

/// Annotiate a setter with [MadobSetter] to add it to the managed object
/// It's inherited from [HiveField]
class MadobSetter extends HiveField {
  /// Adds an setter with corresponding [index]
  const MadobSetter(int index) : super(index);
}
