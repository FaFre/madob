import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed_error.dart';

class HiveRepositoryImplementation {
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

  void register<T extends HiveObject>(String boxName, TypeAdapter<T> adapter) {
    assert(boxName != null && boxName.isNotEmpty);
    assert(adapter != null);

    _throwIfNotInitialized();

    if (_boxCache.containsKey(T)) {
      throw HiveManagedError('Type $T is already registered');
    }

    if (_boxCache.containsValue(boxName)) {
      throw HiveManagedError('Box $boxName is already registered');
    }

    hiveInterface.registerAdapter(adapter);
    _boxCache.putIfAbsent(T, () => boxName);
  }

  String getBoxName<T extends HiveObject>() {
    _throwIfNotInitialized();

    if (!_boxCache.containsKey(T)) {
      throw HiveManagedError('Unknown $T has not been registered');
    }

    return _boxCache[T];
  }
}
