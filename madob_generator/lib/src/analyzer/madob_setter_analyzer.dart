import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../../madob_generator.dart';
import '../helper/accessor_helper.dart';
import '../madob_generator_error.dart';

class MadobSetterAnalyzer {
  static const _madobSetterTypeChecker = TypeChecker.fromRuntime(MadobSetter);

  final ClassElement _madobClass;

  void _checkMethodIsPublic(MethodElement method) {
    if (method.isPrivate) {
      throw MadobGeneratorError(
          '@$MadobSetter can only be assigned to public methods.'
          '${method.name} is private');
    }
  }

  void _checkBoundTypeArguments(
      DartType type, String typeName, List<String> boundTypes) {
    assert(type != null);
    assert(typeName != null);
    assert(typeName.isNotEmpty);
    assert(boundTypes != null);

    if (type is! InterfaceType) {
      throw MadobGeneratorError('Called on wrong type: ${type.element.name}');
    }

    final interface = type as InterfaceType;

    if (type.element.name != typeName) {
      throw MadobGeneratorError('Type check failed for ${type.element.name}. '
          'Its not of type $typeName');
    }

    if (interface.typeArguments.length != boundTypes.length) {
      throw MadobGeneratorError(
          'Number of arguments for ${type.element.name} does not match. '
          'Actual: ${interface.typeArguments.length} '
          'Expected: ${boundTypes.length}');
    }

    for (var i = 0; i < boundTypes.length; i++) {
      // call getDisplayString() for void
      final typeName = interface.typeArguments[i].element?.name ??
          interface.typeArguments[i].getDisplayString();

      if (typeName != boundTypes[i]) {
        throw MadobGeneratorError(
            'Type arguments for ${type.element.name} does not match. '
            'Actual: $typeName '
            'Expected: ${boundTypes[i]}');
      }
    }
  }

  void _checkMethodParamLength(MethodElement method) {
    if (method.parameters.length != 1) {
      throw MadobGeneratorError(
          'Setters are expected to have one single parameter.'
          '${method.name} has ${method.parameters.length} params');
    }
  }

  void _checkTypeArguments(MethodElement method) {
    try {
      _checkBoundTypeArguments(method.returnType, "Future", ['void']);
    }
    // ignore: avoid_catching_errors
    on MadobGeneratorError catch (e) {
      throw MadobGeneratorError(
          'Return type for setters always have to be of Future<void>. '
          '${method.name} is ${method.returnType}. Details: ${e.message}');
    }
  }

  MadobSetterAnalyzer(this._madobClass) : assert(_madobClass != null);

  Map<int, MethodElement> validateAndGet() {
    final setterList = <int, MethodElement>{};

    for (var method in _madobClass.methods) {
      if (!_madobSetterTypeChecker.hasAnnotationOf(method)) {
        continue;
      }

      _checkMethodIsPublic(method);
      _checkMethodParamLength(method);
      _checkTypeArguments(method);

      AccessorHelper.putAccessorIfAbsent(
          _madobSetterTypeChecker, setterList, method);
    }

    return setterList;
  }
}
