import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:madob_generator/src/analyzer/madob_key_analyzer.dart';
import 'package:source_gen/source_gen.dart';

import 'analyzer/madob_getter_analyzer.dart';
import 'analyzer/madob_setter_analyzer.dart';
import 'analyzer/madob_type_analyzer.dart';
import 'annotations/madob_type.dart';
import 'helper/accessor_helper.dart';

class HiveObjectGenerator extends GeneratorForAnnotation<MadobType> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final madobClass = MadobTypeAnalyzer(element).validateAndGet();

    final key = MadobKeyAnalyzer(madobClass).validateAndGet();

    final getterList = MadobGetterAnalyzer(madobClass).validateAndGet();
    final setterList = MadobSetterAnalyzer(madobClass).validateAndGet();

    AccessorHelper.checkInconsistentAccessors(getterList, setterList);
    AccessorHelper.checkMatchingAccessorTypes(getterList, setterList);

    return null;
  }
}
