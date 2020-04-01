import 'package:hive/hive.dart';

/// Annotate a getter with [MadobGetter] to add it as a managed Madob-property
/// It is inherited from [HiveField]
class MadobGetter extends HiveField {
  /// Add a getter with corresponding [index]
  const MadobGetter(int index) : super(index);
}
