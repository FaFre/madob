import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed_error.dart';

class HiveRepository {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  @visibleForTesting
  static HiveInterface hiveInterface = Hive;

  static final Map<Type, String> _boxCache = {};

  static void _throwNotInitialized() =>
      throw HiveManagedError('Repository is not initialized');

  static void init(String path) {
    assert(path != null && path.isNotEmpty);

    if (isInitialized) {
      throw HiveManagedError('Repository is already initialized');
    }

    if (!isInitialized) {
      hiveInterface.init(path);
      _isInitialized = true;
    }
  }

  static void register<T extends HiveObject>(
      String boxName, TypeAdapter<T> adapter) {
    assert(boxName != null && boxName.isNotEmpty);
    assert(adapter != null);

    if (!isInitialized) {
      _throwNotInitialized();
    }

    if (_boxCache.containsKey(T)) {
      throw HiveManagedError('Type $T is already registered');
    }

    if (_boxCache.containsValue(boxName)) {
      throw HiveManagedError('Box $boxName is already registered');
    }

    hiveInterface.registerAdapter(adapter);
    _boxCache.putIfAbsent(T, () => boxName);
  }

  static String getBoxName<T extends HiveObject>() {
    //TODO: validation exceptions
    if (!isInitialized) {
      _throwNotInitialized();
    }

    if (!_boxCache.containsKey(T)) {
      throw HiveManagedError('Unknown $T has not been registered');
    }

    return _boxCache[T];
  }
}
