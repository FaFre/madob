import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';
import '../helper/extensions/string_capitalize.dart';

class HiveObjectBuilder {
  final _formatter = DartFormatter();

  final MadobClass typeClass;
  final MadobKey key;
  final Map<int, MadobProperty> properties;

  CodeExpression _hiveTypeAnnotation(int typeId) =>
      CodeExpression(Code('$HiveType(typeId: $typeId)'));

  CodeExpression _hiveFieldAnnotation(int index) =>
      CodeExpression(Code('$HiveField($index)'));

  CodeExpression _overrideAnnotation() =>
      const CodeExpression(Code('override'));

  Field _managedKeyField() {
    return Field((fb) => fb
      ..type = refer(key.type)
      ..name = '_id'
      ..modifier = FieldModifier.final$
      ..annotations.add(_hiveFieldAnnotation(0)));
  }

  Method _managedKeyGetter() {
    return Method((mb) => mb
      ..type = MethodType.getter
      ..name = 'managedKey'
      ..lambda = true
      ..body = Code('_id')
      ..returns = refer(key.type)
      ..annotations.add(_overrideAnnotation()));
  }

  List<Field> _hiveFields() {
    final fields = <Field>[];
    properties.forEach((key, value) => fields.add(Field((fb) => fb
      ..type = refer(value.type)
      ..name = '_${value.name}'
      ..annotations.add(_hiveFieldAnnotation(key)))));

    return fields;
  }

  List<Method> _accessors() {
    final accessors = <Method>[];
    properties.forEach((key, value) => accessors
      ..add(Method((mb) => mb
        ..type = MethodType.getter
        ..name = value.name
        ..lambda = true
        ..body = Code('Future.value(_${value.name})')
        ..returns = refer('Future<${value.type}>')
        ..annotations.add(_overrideAnnotation())))
      ..add(Method((mb) => mb
        ..name = 'set${value.name.capitalize()}'
        ..requiredParameters.add(Parameter((pb) => pb
          ..type = refer(value.type)
          ..name = 'new${value.name.capitalize()}'))
        ..body = Code('_${value.name} = new${value.name.capitalize()};')
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..annotations.add(_overrideAnnotation()))));

    return accessors;
  }

  HiveObjectBuilder(
      {@required this.typeClass, @required this.key, @required this.properties})
      : assert(typeClass != null),
        assert(key != null),
        assert(properties != null);

  String build() {
    var hiveType = Class((b) => b
      ..name = typeClass.name
      ..extend = refer('$HiveObject', 'package:hive/hive.dart')
      ..implements.add(refer(typeClass.interface))
      ..annotations.add(_hiveTypeAnnotation(typeClass.typeId))
      ..fields.add(_managedKeyField())
      ..methods.add(_managedKeyGetter())
      ..fields.addAll(_hiveFields())
      ..methods.addAll(_accessors()));

    return _formatter.format(hiveType.accept(DartEmitter()).toString());
  }
}
