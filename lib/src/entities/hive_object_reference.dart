import 'package:hive/hive.dart';

abstract class HiveObjectReference<T extends HiveObject> {
  T hiveObject;
}
