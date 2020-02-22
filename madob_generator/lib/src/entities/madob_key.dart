import 'package:analyzer/dart/element/element.dart';
import 'package:madob/madob.dart';

/// Contains information about a `managedKey`
/// to generate a future key for [IKey].
class MadobKey {
  /// [Type]-name of the key
  final String type;

  /// Initializes [type] with information from [accessor]
  MadobKey(PropertyAccessorElement accessor)
      : assert(accessor != null),
        type = accessor.returnType.element.name;
}
