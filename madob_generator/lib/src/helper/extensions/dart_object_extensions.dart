import 'package:analyzer/dart/constant/value.dart';

import '../../madob_generator_error.dart';

/// Adds [getSuperField] functionality
extension SuperField on DartObject {
  /// Returns [DartObject] for [fieldName] from the super-class
  DartObject getSuperField(String fieldName) {
    assert(fieldName != null);
    assert(fieldName.isNotEmpty);

    final superField = getField('(super)');
    if (superField == null) {
      throw MadobGeneratorError('${type.element.name} is not inherited');
    }

    return superField.getField(fieldName);
  }
}
