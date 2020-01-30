import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed_error.dart';

class HiveRepository {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

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

  String getBoxName<K extends HiveObject>() {
    _throwIfNotInitialized();
    _throwIfNotRegistered<K>();

    return _boxCache[K];
  }

  Future<void> closeBox<K extends HiveObject>() async {
    _throwIfNotInitialized();
    _throwIfNotRegistered<K>();

    final boxName = getBoxName<K>();

    if (hiveInterface.isBoxOpen(boxName)) {
      await hiveInterface.box<K>(boxName).close();
    }
  }
}
