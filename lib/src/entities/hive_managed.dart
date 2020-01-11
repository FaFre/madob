import 'package:hive/hive.dart';
import 'package:hive_managed/src/entities/hive_object_reference.dart';

class HiveManaged<T extends HiveObject, I extends HiveObjectReference<T>> {
  I _hiveInstance;
}