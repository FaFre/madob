import 'package:analyzer/dart/element/type.dart';

/// Adds [getGenericBoundTypes] functionality
extension BoundTypes on DartType {
  /// Returns a [List] of all generic bound [Type]-names of a class
  List<String> getGenericBoundTypes() {
    if (this is! InterfaceType) {
      return null;
    }

    var interface = this as InterfaceType;
    var typeList = <String>[];

    for (var arg in interface.typeArguments) {
      typeList.add(arg.element.name);
    }

    return typeList;
  }
}
