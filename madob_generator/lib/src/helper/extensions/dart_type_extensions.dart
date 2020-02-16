import 'package:analyzer/dart/element/type.dart';

extension BoundTypes on DartType {
  List<String> getGenericBoundTypes() {
    if (this is! InterfaceType) {
      return null;
    }

    var interface = this as InterfaceType;
    var typeList = <String>[];

    for (var arg in interface.typeArguments) {
      typeList.add(arg.getDisplayString());
    }

    return typeList;
  }
}
