import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';
import 'base_builder.dart';

/// Generates a [HiveObject]
class HiveObjectBuilder extends BaseBuilder {
  static const _idField = '_id';

  Field _managedKeyField() {
    return Field((fb) => fb
      ..type = refer(key.type)
      ..name = _idField
      ..modifier = FieldModifier.final$
      ..annotations.add(hiveFieldAnnotation(0)));
  }

  Method _managedKeyGetter() {
    return Method((mb) => mb
      ..type = MethodType.getter
      ..name = 'managedKey'
      ..lambda = true
      ..body = Code(_idField)
      ..returns = refer(key.type)
      ..annotations.add(overrideAnnotation()));
  }

  List<Field> _hiveFields() {
    final fields = <Field>[];
    properties.forEach((key, value) => fields.add(Field((fb) => fb
      ..type = refer(value.type)
      ..name = '_${value.getName}'
      ..annotations.add(hiveFieldAnnotation(key)))));

    return fields;
  }

  List<Method> _accessors() {
    final accessors = <Method>[];
    properties.forEach((key, value) => accessors
      ..add(Method((mb) => mb
        ..type = MethodType.getter
        ..name = value.getName
        ..lambda = true
        ..body = Code('Future.value(_${value.getName})')
        ..returns = refer('Future<${value.type}>')
        ..annotations.add(overrideAnnotation())))
      ..add(Method((mb) => mb
        ..name = value.setName
        ..requiredParameters.add(Parameter((pb) => pb
          ..type = refer(value.type)
          ..name = '${value.setParameterName}'))
        ..lambda = true
        ..body = Code('_${value.getName} = ${value.setParameterName}')
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..annotations.add(overrideAnnotation()))));

    return accessors;
  }

  Constructor _constructor() {
    return Constructor((cb) => cb
      ..requiredParameters.add(Parameter((pb) => pb
        ..toThis = true
        ..name = _idField))
      ..initializers
          .add(Code('assert($_idField != null && $_idField.isNotEmpty)')));
  }

  /// Initializes [BaseBuilder]
  HiveObjectBuilder(
      {@required MadobClass typeClass,
      @required MadobKey key,
      @required Map<int, MadobProperty> properties})
      : super(typeClass: typeClass, key: key, properties: properties);

  /// Generates a [HiveObject]-class
  String build() {
    var hiveType = Class((b) => b
      ..name = typeClass.name
      ..extend = refer('$HiveObject', 'package:hive/hive.dart')
      ..implements.add(refer(typeClass.interface))
      ..annotations.add(hiveTypeAnnotation(typeClass.typeId))
      ..fields.add(_managedKeyField())
      ..methods.add(_managedKeyGetter())
      ..fields.addAll(_hiveFields())
      ..methods.addAll(_accessors())
      ..constructors.add(_constructor()));

    return formatter.format(hiveType.accept(DartEmitter()).toString());
  }
}
