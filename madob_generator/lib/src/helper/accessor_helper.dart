import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../madob_generator_error.dart';

import 'extensions/dart_object_extensions.dart';
import 'extensions/dart_type_extensions.dart';
import 'extensions/iterable_extensions.dart';

class AccessorHelper {
  static int getFieldId(DartObject annotiation) {
    assert(annotiation != null);

    return annotiation.getSuperField('index').toIntValue();
  }

  static V putAccessorIfAbsent<V extends Element>(
      TypeChecker checker, Map<int, V> map, V accessor) {
    var annotation = checker.firstAnnotationOf(accessor);

    var index = getFieldId(annotation);
    if (map.containsKey(index)) {
      throw MadobGeneratorError("Double registration for getter or setter "
          "${accessor.name} with Id $index");
    }

    return map.putIfAbsent(index, () => accessor);
  }

  static void checkInconsistentAccessors(
      Map<int, PropertyAccessorElement> getterList,
      Map<int, MethodElement> setterList) {
    assert(getterList != null);
    assert(setterList != null);

    getterList.keys.intersect(
        setterList.keys,
        (missing) =>
            throw MadobGeneratorError("No appropriate setter found for getter "
                "'${getterList[missing].name}' by Id '$missing'"));

    setterList.keys.intersect(
        getterList.keys,
        (missing) =>
            throw MadobGeneratorError("No appropriate getter found for setter "
                "'${setterList[missing].name}' by Id '$missing'"));
  }

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
            '${getValue.returnType.getDisplayString()}');
      }

      var setValueParamName = setValue.parameters.first.type.getDisplayString();

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
