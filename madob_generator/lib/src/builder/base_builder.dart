import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';

/// Provides base members and helpers to generate *Object* classes
class BaseBuilder {
  /// Instance of [DartFormatter]
  final DartFormatter formatter = DartFormatter();

  /// Class information
  final MadobClass typeClass;

  /// Key information
  final MadobKey key;

  /// Property information
  final Map<int, MadobProperty> properties;

  /// Generates a [HiveType] annotation
  @protected
  CodeExpression hiveTypeAnnotation(int typeId) =>
      CodeExpression(Code('$HiveType(typeId: $typeId)'));

  /// Generates a [HiveField] annotation
  @protected
  CodeExpression hiveFieldAnnotation(int index) =>
      CodeExpression(Code('$HiveField($index)'));

  /// Generates a [override] annotation
  @protected
  CodeExpression overrideAnnotation() => const CodeExpression(Code('override'));

  /// Initializes the [BaseBuilder]
  BaseBuilder(
      {@required this.typeClass, @required this.key, @required this.properties})
      : assert(typeClass != null),
        assert(key != null),
        assert(properties != null);
}
