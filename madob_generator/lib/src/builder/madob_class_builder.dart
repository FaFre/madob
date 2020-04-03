import 'package:code_builder/code_builder.dart';
import 'package:madob/madob.dart';
import 'package:meta/meta.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';
import '../scheme/madob_schemes.dart';
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
    Code generateGetBody(MadobProperty property) {
      if (property.isReferenced) {
        return Code('final value = '
            'await getOrUpdateReference<${property.referencedHiveObject}>'
            '((${typeClass.name.toLowerCase()}) async '
            '=> await ${typeClass.name.toLowerCase()}.${property.getName},'
            '(${typeClass.name.toLowerCase()}, '
            '${property.setParameterName}) => '
            '${typeClass.name.toLowerCase()}'
            '.${property.setName}'
            '(${property.setParameterName}));'
            'return Future.value((value != null) ? ('
            '$madobClassPrefix${property.referencedHiveObject}()..hiveObject ='
            'value) : null);');
      }

      return Code('getValue((${typeClass.name.toLowerCase()}) '
          '=> ${typeClass.name.toLowerCase()}.${property.getName})');
    }

    Code generateSetBody(MadobProperty property) {
      if (property.isReferenced) {
        final referenceParam = (property.isReferenceManaged)
            ? '(${property.setParameterName} is '
                '$madobClassPrefix${property.referencedHiveObject}) ? '
                '${property.setParameterName}.hiveObject : '
                '${property.setParameterName}'
            : property.setParameterName;

        return Code('setReference<${property.referencedHiveObject}>'
            '($referenceParam, (${typeClass.name.toLowerCase()}, '
            '${property.setParameterName}) => '
            '${typeClass.name.toLowerCase()}'
            '.${property.setName}'
            '(${property.setParameterName}))');
      }

      return Code('setValue((${typeClass.name.toLowerCase()}) => '
          '${typeClass.name.toLowerCase()}'
          '.${property.setName}'
          '(${property.setParameterName}))');
    }

    final accessors = <Method>[];
    properties.forEach((key, value) => accessors
      ..add(Method((mb) => mb
        ..type = MethodType.getter
        ..name = value.getName
        ..lambda = !value.isReferenced
        ..modifier = value.isReferenced ? MethodModifier.async : null
        ..body = generateGetBody(value)
        ..returns = refer('Future<${value.type}>')
        ..annotations.add(overrideAnnotation())))
      ..add(Method((mb) => mb
        ..name = value.setName
        ..requiredParameters.add(Parameter((pb) => pb
          ..type = refer(value.type)
          ..name = value.setParameterName))
        ..lambda = true
        ..body = generateSetBody(value)
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
      ..name = '$madobClassPrefix${typeClass.name}'
      ..extend = refer('Madob<${typeClass.name}>')
      ..implements.add(refer(typeClass.interface))
      ..methods.add(_managedKeyField())
      ..methods.addAll(_accessors()));

    return formatter.format(madobClass.accept(DartEmitter()).toString());
  }
}
