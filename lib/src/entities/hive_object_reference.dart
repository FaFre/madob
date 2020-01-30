import 'package:hive/hive.dart';

import '../hive_manager.dart';
import 'hive_managed.dart';

/// Is implemented by [HiveManaged] to expose [E] to [HiveManager].
abstract class HiveObjectReference<E extends HiveObject> {
  /// Instance of the [HiveObject] that is **fully managed** by [HiveManaged]
  E hiveObject;
}
