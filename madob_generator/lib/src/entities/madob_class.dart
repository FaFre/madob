import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

class MadobClass {
  final int typeId;
  final String interface;
  String get name => interface?.substring(1);

  MadobClass(ConstantReader annotation, ClassElement interface)
      : assert(annotation != null),
        assert(interface != null),
        typeId = annotation.read('typeId').intValue,
        interface = interface.name;
}
