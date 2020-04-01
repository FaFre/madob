import 'package:madob/madob.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../scheme/madob_schemes.dart';

/// Contains information about a property
/// to generate a future setter/getter for [HiveObject] and [Madob]
class MadobProperty {
  /// [Type]-name of the property
  final String type;

  /// Name of the referenced class.
  /// Could be a [HiveObject] or abstract class for generation
  final String referencedClass;

  /// Name of the referenced class, converted to a generated [HiveObject]-name
  /// in case a abstract class is given
  String get referencedHiveObject =>
      hasInterfaceNamingConvention(referencedClass)
          ? referencedClass.substring(1)
          : referencedClass;

  /// Returns if the property is referenced to another Object
  bool get isReferenced => (referencedClass?.isNotEmpty == true);

  /// If the reference pointing to a Madob-Object
  final bool isReferenceManaged;

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
      this.referencedClass,
      this.isReferenceManaged});
}
