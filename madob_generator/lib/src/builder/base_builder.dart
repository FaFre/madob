import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';

class BaseBuilder {
  final formatter = DartFormatter();

  final MadobClass typeClass;
  final MadobKey key;
  final Map<int, MadobProperty> properties;

  @protected
  CodeExpression hiveTypeAnnotation(int typeId) =>
      CodeExpression(Code('$HiveType(typeId: $typeId)'));

  @protected
  CodeExpression hiveFieldAnnotation(int index) =>
      CodeExpression(Code('$HiveField($index)'));

  @protected
  CodeExpression overrideAnnotation() => const CodeExpression(Code('override'));

  BaseBuilder(
      {@required this.typeClass, @required this.key, @required this.properties})
      : assert(typeClass != null),
        assert(key != null),
        assert(properties != null);
}
