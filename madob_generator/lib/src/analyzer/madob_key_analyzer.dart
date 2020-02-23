import 'package:analyzer/dart/element/element.dart';

import '../madob_generator_error.dart';

/// Analyzer to determine and validate the `managedKey`
class MadobKeyAnalyzer {
  static const _allowedKeyTypes = ['String', 'int'];

  final ClassElement _madobClass;

  void _checkKeyType(PropertyAccessorElement accessor) {
    if (!_allowedKeyTypes.contains(accessor.returnType.element.name)) {
      throw MadobGeneratorError(
          "'managedKey' type of ${accessor.returnType.element.name} "
          "is not supported. Supported types are: "
          "${_allowedKeyTypes.join(',')}");
    }
  }

  /// Initializes [MadobKeyAnalyzer]
  MadobKeyAnalyzer(this._madobClass) : assert(_madobClass != null);

  /// Run validations and return `managedKey` getter
  PropertyAccessorElement validateAndGet() {
    var getter = _madobClass.accessors.firstWhere((accessor) =>
        accessor.name == 'managedKey' &&
        accessor.isGetter &&
        accessor.isPublic);
    if (getter == null) {
      // should never happen, because IKey implementation is already checked
      throw MadobGeneratorError(
          "${_madobClass.name} does not implement getter 'managedKey'");
    }

    _checkKeyType(getter);

    return getter;
  }
}
