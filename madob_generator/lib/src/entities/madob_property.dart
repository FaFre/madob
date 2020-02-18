import 'package:analyzer/dart/element/element.dart';

import '../helper/extensions/dart_type_extensions.dart';

class MadobProperty {
  final String type;
  final String name;

  MadobProperty(PropertyAccessorElement accessor)
      : assert(accessor != null),
        type = accessor.returnType.getGenericBoundTypes().first,
        name = accessor.name;
}
