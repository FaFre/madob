import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';
import '../helper/extensions/string_capitalize.dart';
import 'base_builder.dart';

class HiveObjectBuilder extends BaseBuilder {
  Field _managedKeyField() {
    return Field((fb) => fb
      ..type = refer(key.type)
      ..name = '_id'
      ..modifier = FieldModifier.final$
      ..annotations.add(hiveFieldAnnotation(0)));
  }

  Method _managedKeyGetter() {
    return Method((mb) => mb
      ..type = MethodType.getter
      ..name = 'managedKey'
      ..lambda = true
      ..body = Code('_id')
      ..returns = refer(key.type)
      ..annotations.add(overrideAnnotation()));
  }

  List<Field> _hiveFields() {
    final fields = <Field>[];
    properties.forEach((key, value) => fields.add(Field((fb) => fb
      ..type = refer(value.type)
      ..name = '_${value.name}'
      ..annotations.add(hiveFieldAnnotation(key)))));

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
        ..annotations.add(overrideAnnotation())))
      ..add(Method((mb) => mb
        ..name = 'set${value.name.capitalize()}'
        ..requiredParameters.add(Parameter((pb) => pb
          ..type = refer(value.type)
          ..name = 'new${value.name.capitalize()}'))
        ..lambda = true
        ..body = Code('_${value.name} = new${value.name.capitalize()}')
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..annotations.add(overrideAnnotation()))));

    return accessors;
  }

  HiveObjectBuilder(
      {@required MadobClass typeClass,
      @required MadobKey key,
      @required Map<int, MadobProperty> properties})
      : super(typeClass: typeClass, key: key, properties: properties);

  String build() {
    var hiveType = Class((b) => b
      ..name = typeClass.name
      ..extend = refer('$HiveObject', 'package:hive/hive.dart')
      ..implements.add(refer(typeClass.interface))
      ..annotations.add(hiveTypeAnnotation(typeClass.typeId))
      ..fields.add(_managedKeyField())
      ..methods.add(_managedKeyGetter())
      ..fields.addAll(_hiveFields())
      ..methods.addAll(_accessors()));

    return formatter.format(hiveType.accept(DartEmitter()).toString());
  }
}
