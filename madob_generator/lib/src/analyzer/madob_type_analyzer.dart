import 'package:analyzer/dart/element/element.dart';
import 'package:madob/madob.dart';

import '../annotations/madob_type.dart';
import '../madob_generator_error.dart';

class MadobTypeAnalyzer {
  ClassElement _classElement;

  MadobTypeAnalyzer(Element annotadedClass) : assert(annotadedClass != null) {
    if (annotadedClass.kind != ElementKind.CLASS) {
      throw MadobGeneratorError(
          '@$MadobType can only be assigned to abstract classes. '
          'Thats not the case for ${_classElement.name}');
    }

    _classElement = annotadedClass as ClassElement;
  }

  void _checkIsAbstract() {
    if (!_classElement.isAbstract) {
      throw MadobGeneratorError(
          '@$MadobType can only be assigned to abstract classes. '
          'Thats not the case for ${_classElement.name}');
    }
  }

  void _checkNamingConvention() {
    if (!_classElement.name.startsWith('I')) {
      throw MadobGeneratorError(
          'Abstract classes with @$MadobType must start with an '
          "'I' character to indicate an interface. "
          'Thats not the case for ${_classElement.name}');
    }
  }

  void _checkImplementsKey() {
    if (!_classElement.interfaces
        .any((interface) => interface.element.name == '$IKey')) {
      throw MadobGeneratorError("@$MadobType classes must implement '$IKey'");
    }
  }

  ClassElement validateAndGet() {
    _checkIsAbstract();
    _checkNamingConvention();
    _checkImplementsKey();

    return _classElement;
  }
}
