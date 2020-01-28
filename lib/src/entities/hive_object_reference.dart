import 'package:hive/hive.dart';

abstract class HiveObjectReference<E extends HiveObject> {
  E hiveObject;
}
