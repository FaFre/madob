import 'package:analyzer/dart/element/element.dart';
import 'package:madob/madob.dart';
import 'package:hive/hive.dart';
import 'package:source_gen/source_gen.dart';

/// Contains class-information to generate
/// future [HiveObject] and [Madob] classes
class MadobClass {
  /// Used to indetify the [HiveType]
  final int typeId;

  /// Name of the implemented object interface
  final String interface;

  /// Final [HiveObject]-class name
  String get name => interface?.substring(1);

  /// Initializes [typeId] and [interface] wit information from
  /// [annotation] and [interface]
  MadobClass(ConstantReader annotation, ClassElement interface)
      : assert(annotation != null),
        assert(interface != null),
        typeId = annotation.read('typeId').intValue,
        interface = interface.name;
}
