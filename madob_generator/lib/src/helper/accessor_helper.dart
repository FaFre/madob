import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../madob_generator_error.dart';

import 'extensions/dart_object_extensions.dart';
import 'extensions/dart_type_extensions.dart';
import 'extensions/iterable_extensions.dart';

/// Generator helpers for accessors
class AccessorHelper {
  /// Returns the [int]-`index` of a [DartObject]'s `super`-class
  static int getFieldId(DartObject annotiation) {
    assert(annotiation != null);

    return annotiation.getSuperField('index').toIntValue();
  }

  /// Returns the referenced [HiveObject] name
  static String getFieldHiveReference(DartObject annotation) {
    assert(annotation != null);

    return annotation.getField('referencedHiveObject').toStringValue();
  }

  /// Returns the referenced [Madob]-class name
  static String getFieldMadobReference(DartObject annotation) {
    assert(annotation != null);

    return annotation.getField('referencedMadobObject').toStringValue();
  }

  /// Validates [accessor] and adds it to [map]
  static V putAccessorIfAbsent<V extends Element>(
      TypeChecker checker, Map<int, V> map, V accessor) {
    final annotation = checker.firstAnnotationOf(accessor);

    final index = getFieldId(annotation);
    if (index <= 0) {
      throw MadobGeneratorError(
          'Index for getter/setter must be >= 1 (Is: $index). '
          'Index 0 is reserved for the key.');
    }
    if (map.containsKey(index)) {
      throw MadobGeneratorError('Double registration for getter or setter '
          '${accessor.name} with Id $index');
    }

    return map.putIfAbsent(index, () => accessor);
  }

  /// Validates if [getterList] and [setterList] both contain the same keys
  static void checkInconsistentAccessors(
      Map<int, PropertyAccessorElement> getterList,
      Map<int, MethodElement> setterList) {
    assert(getterList != null);
    assert(setterList != null);

    getterList.keys.except(
        setterList.keys,
        (missing) =>
            throw MadobGeneratorError('No appropriate setter found for getter '
                "'${getterList[missing].name}' by Id '$missing'"));

    setterList.keys.except(
        getterList.keys,
        (missing) =>
            throw MadobGeneratorError('No appropriate getter found for setter '
                "'${setterList[missing].name}' by Id '$missing'"));
  }

  /// Validates if the getter returns the same [Type] as the setter takes
  /// and if the type is valid
  static void checkMatchingAccessorTypes(
      Map<int, PropertyAccessorElement> getterList,
      Map<int, MethodElement> setterList) {
    assert(getterList != null);
    assert(setterList != null);

    getterList.forEach((getKey, getValue) {
      var setValue = setterList[getKey];

      var getterReturnBoundTypes = getValue.returnType.getGenericBoundTypes();
      if (getterReturnBoundTypes == null) {
        throw MadobGeneratorError('Getters always have to return a Future<T>. '
            '${getValue.name} returns '
            '${getValue.returnType.element.name}');
      }

      // parameter count already checked
      var setValueParamName = setValue.parameters.first.type.element.name;

      if (getterReturnBoundTypes.first != setValueParamName) {
        throw MadobGeneratorError(
            'Getter and setter should both based on the same type. '
            '${getValue.name} returns Future of'
            '${getterReturnBoundTypes.first}. '
            '${setValue.name} takes $setValueParamName');
      }
    });
  }
}
