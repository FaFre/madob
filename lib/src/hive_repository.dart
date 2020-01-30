import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../src/hive_managed_error.dart';

/// Handles [HiveObject]'s to [Box]-name relations
class HiveRepository {
  bool _isInitialized = false;

  /// Initialization status of [HiveRepository]
  bool get isInitialized => _isInitialized;

  /// **Warning:** [hiveInterface] is only changed for
  /// **unit-test purposes** to allow mocking.
  @visibleForTesting
  HiveInterface hiveInterface = Hive;

  final Map<Type, String> _boxCache = {};

  void _throwIfNotInitialized() {
    if (!isInitialized) {
      throw HiveManagedError('Repository is not initialized');
    }
  }

  void _throwIfNotRegistered<T>() {
    if (!_boxCache.containsKey(T)) {
      throw HiveManagedError('Unknown $T has not been registered');
    }
  }

  /// Initializes [HiveRepository] with a given [path] which is used
  /// as a [Hive] database path.
  /// Also see [Hive.init()]
  void init(String path) {
    assert(path != null && path.isNotEmpty);

    if (isInitialized) {
      throw HiveManagedError('Repository is already initialized');
    }

    if (!isInitialized) {
      hiveInterface.init(path);
      _isInitialized = true;
    }
  }

  /// Register a [HiveObject] to [Box]-name relation, as well as
  /// the required [TypeAdapter] for [Hive]
  void register<K extends HiveObject>(String boxName, TypeAdapter<K> adapter) {
    assert(boxName != null && boxName.isNotEmpty);
    assert(adapter != null);

    _throwIfNotInitialized();

    if (_boxCache.containsKey(K)) {
      throw HiveManagedError('Type $K is already registered');
    }

    if (_boxCache.containsValue(boxName)) {
      throw HiveManagedError('Box $boxName is already registered');
    }

    hiveInterface.registerAdapter(adapter);
    _boxCache.putIfAbsent(K, () => boxName);
  }

  /// Returns the related [Box]-name for [K]
  String getBoxName<K extends HiveObject>() {
    _throwIfNotInitialized();
    _throwIfNotRegistered<K>();

    return _boxCache[K];
  }

  /// Explicitly closes the [Box] for [K]
  Future<void> closeBox<K extends HiveObject>() async {
    _throwIfNotInitialized();
    _throwIfNotRegistered<K>();

    final boxName = getBoxName<K>();

    if (hiveInterface.isBoxOpen(boxName)) {
      await hiveInterface.box<K>(boxName).close();
    }
  }
}
