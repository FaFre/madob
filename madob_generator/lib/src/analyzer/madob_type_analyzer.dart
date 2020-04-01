import 'package:analyzer/dart/element/element.dart';
import 'package:madob/madob.dart';

import '../annotations/madob_type.dart';
import '../madob_generator_error.dart';
import '../scheme/madob_schemes.dart';

/// [MadobType] validator and converter
class MadobTypeAnalyzer {
  ClassElement _classElement;

  /// Initialize [MadobTypeAnalyzer] with [annotatedClass]
  /// and validates [ElementKind]
  MadobTypeAnalyzer(Element annotatedClass) : assert(annotatedClass != null) {
    if (annotatedClass.kind != ElementKind.CLASS) {
      throw MadobGeneratorError(
          '@$MadobType can only be assigned to abstract classes. '
          "That's not the case for ${_classElement.name}");
    }

    _classElement = annotatedClass as ClassElement;
  }

  void _checkIsAbstract() {
    if (!_classElement.isAbstract) {
      throw MadobGeneratorError(
          '@$MadobType can only be assigned to abstract classes. '
          "That's not the case for ${_classElement.name}");
    }
  }

  void _checkNamingConvention() {
    if (!hasInterfaceNamingConvention(_classElement.name)) {
      throw MadobGeneratorError(
          'Abstract classes with @$MadobType must start with an '
          "'I' character to indicate an interface. "
          "That's not the case for ${_classElement.name}");
    }
  }

  void _checkImplementsKey() {
    if (!_classElement.interfaces
        .any((interface) => interface.element.name == '$IKey')) {
      throw MadobGeneratorError("@$MadobType classes must implement '$IKey'");
    }
  }

  /// Run validations and return converted [Element]
  ClassElement validateAndGet() {
    _checkIsAbstract();
    _checkNamingConvention();
    _checkImplementsKey();

    return _classElement;
  }
}
