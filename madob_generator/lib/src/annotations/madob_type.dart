import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

class MadobType extends HiveType {
  const MadobType({@required int typeId, String adapterName})
      : super(typeId: typeId, adapterName: adapterName);
}
