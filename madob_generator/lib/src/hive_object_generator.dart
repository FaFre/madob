import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:madob_generator/src/builder/madob_class_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'analyzer/madob_getter_analyzer.dart';
import 'analyzer/madob_key_analyzer.dart';
import 'analyzer/madob_setter_analyzer.dart';
import 'analyzer/madob_type_analyzer.dart';
import 'annotations/madob_type.dart';
import 'builder/hive_object_builder.dart';
import 'entities/madob_class.dart';
import 'entities/madob_key.dart';
import 'entities/madob_property.dart';
import 'helper/accessor_helper.dart';

class HiveObjectGenerator extends GeneratorForAnnotation<MadobType> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final madobClass = MadobTypeAnalyzer(element).validateAndGet();

    final managedKey = MadobKeyAnalyzer(madobClass).validateAndGet();

    final getterList = MadobGetterAnalyzer(madobClass).validateAndGet();
    final setterList = MadobSetterAnalyzer(madobClass).validateAndGet();

    AccessorHelper.checkInconsistentAccessors(getterList, setterList);
    AccessorHelper.checkMatchingAccessorTypes(getterList, setterList);

    final objectBuilder = HiveObjectBuilder(
        typeClass: MadobClass(annotation, madobClass),
        key: MadobKey(managedKey),
        properties: getterList
            .map((key, value) => MapEntry(key, MadobProperty(value))));

    final classBuilder = MadobClassBuilder(
        typeClass: MadobClass(annotation, madobClass),
        key: MadobKey(managedKey),
        properties: getterList
            .map((key, value) => MapEntry(key, MadobProperty(value))));

    return '${objectBuilder.build()}'
        '\n\n'
        '${classBuilder.build()}';
  }
}
