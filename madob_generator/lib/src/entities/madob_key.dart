import 'package:analyzer/dart/element/element.dart';

class MadobKey {
  final String type;

  MadobKey(PropertyAccessorElement accessor)
      : assert(accessor != null),
        type = accessor.returnType.element.name;
}
