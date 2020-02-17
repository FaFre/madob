import 'package:hive/hive.dart';

import '../hive_manager.dart';
import 'madob.dart';

/// Is implemented by [Madob] to expose [E] to [HiveManager].
abstract class HiveObjectReference<E extends HiveObject> {
  /// Instance of the [HiveObject] that is **fully managed** by [Madob]
  E hiveObject;
}
