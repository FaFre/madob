import 'package:hive/hive.dart';

import '../entities/madob.dart';
import '../helper/strong_uuid.dart';

/// Implement [IKey] and inherit from [HiveObject]
/// to make an object usable for [Madob]
abstract class IKey {
  /// Getter of object identifier. Also used as a **hive-key**.
  /// Also see [StrongUuid] and [Madob.getId()].
  /// The key must be either of type [int] or [String].
  /// (This may change with future versions)
  dynamic get managedKey;
}
