import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/hive_managed_error.dart';
import 'package:hive_managed/src/entities/hive_object_reference.dart';
import 'package:hive_managed/src/entities/key.dart';
import 'package:hive_managed/src/hive_repository.dart';
import 'package:meta/meta.dart';

class HiveManager<T extends HiveObject> {
  static final Map<Type, HiveManager> _managerCache = {};

  @visibleForTesting
  static HiveInterface hiveInterface = Hive;

  @visibleForTesting
  static HiveRepositoryImplementation hiveRepository = HiveRepository;

  void _checkInstanceOnNull(HiveObjectReference<T> instance) {
    if (instance.hiveObject == null) {
      throw HiveManagedError(
          'Cannot work with empty/null instance of $T in $HiveObjectReference');
    }
  }

  dynamic _getValidIdOrThrow(T instance) {
    final id = getId(instance);
    if (id == null) {
      throw HiveManagedError(
          'Instance of $T is not in a box. Id of the object is null. Valid Id is required for all operations');
    }

    return id;
  }

  dynamic getId(T instance) {
    assert(instance != null);

    if (instance is! IKey) {
      throw HiveManagedError(
          'Unable to get Id because $T does not implement $IKey');
    }

    return (instance as IKey).managedKey;
  }

  Future<Box<T>> getBox() async {
    return hiveInterface.openBox(hiveRepository.getBoxName<T>());
  }

  Future<void> _put(T instance) async =>
      (await getBox()).put(getId(instance), instance);

  Future<T> _get(dynamic key) async => (await getBox()).get(key);

  Future<void> ensureAndModify(HiveObjectReference<T> instance) async {
    assert(instance != null);

    _checkInstanceOnNull(instance);

    instance.hiveObject = await ensureAndReturn(instance.hiveObject);
  }

  Future<T> ensureAndReturn(T instance) async {
    assert(instance != null);

    if (!instance.isInBox) {
      final id = _getValidIdOrThrow(instance);

      final existingItem = await _get(id);
      if (existingItem != null) {
        return existingItem;
      } else {
        await _put(instance);
      }
    }

    return instance;
  }

  Future<R> getValue<R>(
      HiveObjectReference<T> hiveInstance, Future<R> Function(T) getValue,
      {uninsuredGet = false}) async {
    assert(hiveInstance != null);
    assert(getValue != null);

    _checkInstanceOnNull(hiveInstance);

    if (!uninsuredGet) await ensureAndModify(hiveInstance);
    return getValue(hiveInstance.hiveObject);
  }

  Future<void> setValue(HiveObjectReference<T> hiveInstance,
      Future<void> Function(T) writeValue) async {
    assert(hiveInstance != null);
    assert(writeValue != null);

    _checkInstanceOnNull(hiveInstance);

    await ensureAndModify(hiveInstance);
    await writeValue(hiveInstance.hiveObject);

    return hiveInstance.hiveObject.save();
  }

  Future<R> setReference<R extends HiveObject>(
      HiveObjectReference<T> hiveInstance,
      R reference,
      Future<void> Function(T, R) setReference) async {
    assert(hiveInstance != null);
    assert(setReference != null);

    _checkInstanceOnNull(hiveInstance);

    await ensureAndModify(hiveInstance);

    R ensuredInstance;
    if (reference != null) {
      ensuredInstance = await HiveManager<R>().ensureAndReturn(reference);
    }

    if (!identical(reference, ensuredInstance)) {
      await setReference(hiveInstance.hiveObject, ensuredInstance);
      await hiveInstance.hiveObject.save();
    }

    return ensuredInstance;
  }

  Future<R> getOrUpdateReference<R extends HiveObject>(
      HiveObjectReference<T> hiveInstance,
      Future<R> Function(T) getReference,
      Future<void> Function(T, R) setReference) async {
    assert(hiveInstance != null);
    assert(getReference != null);
    assert(setReference != null);

    return this.setReference(hiveInstance,
        await getReference(hiveInstance.hiveObject), setReference);
  }

  Future<void> delete(HiveObjectReference<T> hiveInstance) async {
    assert(hiveInstance != null);

    _checkInstanceOnNull(hiveInstance);

    if (!hiveInstance.hiveObject.isInBox) {
      final id = _getValidIdOrThrow(hiveInstance.hiveObject);

      final existingItem = await _get(id);
      if (existingItem == null) {
        throw HiveManagedError(
            'Cannot delete object because no item with id $id exists');
      } else {
        hiveInstance.hiveObject = existingItem;
      }
    }

    await hiveInstance.hiveObject.delete();
    hiveInstance.hiveObject = null;
  }

  HiveManager._internal();

  factory HiveManager() {
    if (_managerCache.containsKey(T)) {
      return _managerCache[T];
    }

    return _managerCache.putIfAbsent(T, () => HiveManager<T>._internal());
  }
}
