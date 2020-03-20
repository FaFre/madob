import 'package:analyzer/dart/element/element.dart';
import 'package:madob/madob.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../helper/extensions/dart_type_extensions.dart';

/// Contains information about a property
/// to generate a future setter/getter for [HiveObject] and [Madob]
class MadobProperty {
  /// [Type]-name of the property
  final String type;

  /// Name of the referenced [HiveObject]
  final String referencedHiveObjectName;

  /// Name of the property
  final String name;

  /// Initializes [type] and [name] with information from [accessor]
  MadobProperty(PropertyAccessorElement accessor,
      {@required this.referencedHiveObjectName})
      : assert(accessor != null),
        type = accessor.returnType.getGenericBoundTypes().first,
        name = accessor.name;
}
