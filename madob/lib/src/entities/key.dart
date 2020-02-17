import 'package:hive/hive.dart';

import '../entities/madob.dart';
import '../helper/strong_uuid.dart';

/// Implement [IKey] and inherit from [HiveObject]
/// to make the object usable for [Madob]
abstract class IKey {
  /// Getter for the object identifier, also used as a **hive-key**.
  /// Also See [StrongUuid] and [Madob.getId()]
  /// The key must be either of type [int] or [String].
  /// This may change with future versions.
  dynamic get managedKey;
}
