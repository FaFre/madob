import 'package:analyzer/dart/element/element.dart';

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
          'Abstract classes with @$MadobType should start with '
          "'I' character to indicate an Interface "
          'thats not the case for ${_classElement.name}');
    }
  }

  ClassElement validateAndGet() {
    _checkIsAbstract();
    _checkNamingConvention();

    return _classElement;
  }
}
