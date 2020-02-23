import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/madob_getter.dart';
import '../helper/accessor_helper.dart';
import '../madob_generator_error.dart';

/// [MadobGetter] validator and converter
class MadobGetterAnalyzer {
  static const _madobGetterTypeChecker = TypeChecker.fromRuntime(MadobGetter);

  final ClassElement _madobClass;

  void _checkAccessorIsPublic(PropertyAccessorElement accessor) {
    if (accessor.isPrivate) {
      throw MadobGeneratorError(
          '@$MadobGetter can only be assigned to public getters');
    }
  }

  void _checkAccessorIsGetter(PropertyAccessorElement accessor) {
    if (!accessor.isGetter) {
      throw MadobGeneratorError(
          '@$MadobGetter can only be assigned to getters');
    }
  }

  /// Initializes [MadobGetterAnalyzer]
  MadobGetterAnalyzer(this._madobClass) : assert(_madobClass != null);

  /// Run validators and return a [Map] of getters.
  /// First type of returned [Map] is of [int] and represents the index
  Map<int, PropertyAccessorElement> validateAndGet() {
    final getterList = <int, PropertyAccessorElement>{};

    for (var accessor in _madobClass.accessors) {
      if (!_madobGetterTypeChecker.hasAnnotationOf(accessor)) {
        continue;
      }

      _checkAccessorIsGetter(accessor);
      _checkAccessorIsPublic(accessor);

      AccessorHelper.putAccessorIfAbsent(
          _madobGetterTypeChecker, getterList, accessor);
    }

    return getterList;
  }
}
