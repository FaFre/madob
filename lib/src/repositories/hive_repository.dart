import 'package:hive/hive.dart';

class HiveRepository {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static final Map<Type, String> _boxCache = {};

  static void init(String path) {
    if (!isInitialized) {
      Hive.init(path);
      _isInitialized = true;
    }
  }

  static void register<T extends HiveObject>(
      String boxName, TypeAdapter<T> adapter) {
    assert(boxName != null && boxName.isNotEmpty);
    assert(adapter != null);

    //TODO: validation exceptions

    Hive.registerAdapter(adapter);
    _boxCache.putIfAbsent(T, () => boxName);
  }

  static String getBoxName<T extends HiveObject>() {
    //TODO: validation exceptions

    return _boxCache[T];
  }
}
