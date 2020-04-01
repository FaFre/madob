import 'package:hive/hive.dart';
import 'package:madob/madob.dart';

/// Annotate a setter with [MadobSetter] to add it as a managed Madob-property
/// It is inherited from [HiveField]
class MadobSetter extends HiveField {
  /// When the property refers to another [HiveObject] it has to be specified.
  /// You can either specify the abstract class used by the generator
  /// e.g. `IProject` or the generated [HiveObject] e.g. `Project`
  final String referencedHiveObject;

  /// When the property refers to another [Madob]-object it has to be specified.
  /// You can either specify the abstract class used by the generator
  /// e.g. `IProject` or the generated [HiveObject] e.g. `Project`
  final String referencedMadobObject;

  /// Add a setter with corresponding [index]
  const MadobSetter(int index,
      {this.referencedHiveObject, this.referencedMadobObject})
      : assert(!(referencedHiveObject != null && referencedMadobObject != null),
            'Use either `referencedHiveObject` or `referencedMadobObject`'),
        super(index);
}
