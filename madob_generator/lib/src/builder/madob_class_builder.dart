import 'package:code_builder/code_builder.dart';
import 'package:madob/madob.dart';
import 'package:meta/meta.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';
import '../helper/extensions/string_capitalize.dart';
import 'base_builder.dart';

/// Generates a [Madob]-class
class MadobClassBuilder extends BaseBuilder {
  Method _managedKeyField() {
    return Method((mb) => mb
      ..type = MethodType.getter
      ..name = 'managedKey'
      ..lambda = true
      ..body = Code('hiveObject.managedKey')
      ..returns = refer(key.type)
      ..annotations.add(overrideAnnotation()));
  }

  List<Method> _accessors() {
    final accessors = <Method>[];
    properties.forEach((key, value) => accessors
      ..add(Method((mb) => mb
        ..type = MethodType.getter
        ..name = value.name
        ..lambda = true
        ..body = Code('getValue((${typeClass.name.toLowerCase()}) '
            '=> ${typeClass.name.toLowerCase()}.${value.name})')
        ..returns = refer('Future<${value.type}>')
        ..annotations.add(overrideAnnotation())))
      ..add(Method((mb) => mb
        ..name = 'set${value.name.capitalize()}'
        ..requiredParameters.add(Parameter((pb) => pb
          ..type = refer(value.type)
          ..name = 'new${value.name.capitalize()}'))
        ..lambda = true
        ..body = Code('setValue((${typeClass.name.toLowerCase()}) => '
            '${typeClass.name.toLowerCase()}'
            '.setTitle(new${value.name.capitalize()}))')
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..annotations.add(overrideAnnotation()))));

    return accessors;
  }

  /// Initializes [BaseBuilder]
  MadobClassBuilder(
      {@required MadobClass typeClass,
      @required MadobKey key,
      @required Map<int, MadobProperty> properties})
      : super(typeClass: typeClass, key: key, properties: properties);

  /// Generates a [Madob]-class
  String build() {
    var madobClass = Class((b) => b
      ..name = 'Managed${typeClass.name}'
      ..extend = refer('Madob<${typeClass.name}>')
      ..implements.add(refer(typeClass.interface))
      ..methods.add(_managedKeyField())
      ..methods.addAll(_accessors()));

    return formatter.format(madobClass.accept(DartEmitter()).toString());
  }
}
