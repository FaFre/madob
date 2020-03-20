import 'package:hive/hive.dart';

/// Annotate a setter with [MadobSetter] to add it to the managed object
/// It's inherited from [HiveField]
class MadobSetter extends HiveField {
  /// When the property refers to another [HiveObject] it has to be specified
  final String referencedHiveObjectName;

  /// Adds an setter with corresponding [index]
  const MadobSetter(int index, {this.referencedHiveObjectName}) : super(index);
}
