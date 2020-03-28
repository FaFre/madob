import 'package:madob/madob.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

/// Contains information about a property
/// to generate a future setter/getter for [HiveObject] and [Madob]
class MadobProperty {
  /// [Type]-name of the property
  final String type;

  /// Name of the referenced [HiveObject]
  final String referencedHiveObjectName;
  bool get isReferenced => referencedHiveObjectName?.isNotEmpty == true;

  /// Getter-Name of the property
  final String getName;

  /// Setter-Name of the property
  final String setName;

  /// Parameter-name of passed 'to-set' variable
  final String setParameterName;

  /// Initializes [type] and [getName] with information from [accessor]
  MadobProperty(
      {@required this.type,
      @required this.getName,
      @required this.setName,
      @required this.setParameterName,
      this.referencedHiveObjectName});
}
