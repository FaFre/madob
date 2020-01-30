import 'package:hive/hive.dart';

import '../entities/hive_managed.dart';
import '../helper/strong_uuid.dart';

/// Implement [IKey] and inherit from [HiveObject]
/// to make the object usable for [HiveManaged]
abstract class IKey {
  /// Getter for the object identifier, also used as a **hive-key**.
  /// Also See [StrongUuid] and [HiveManaged.getId()]
  dynamic get managedKey;
}
