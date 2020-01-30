import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../hive_managed.dart';
import '../hive_managed_error.dart';
import 'entities/hive_object_reference.dart';
import 'entities/key.dart';
import 'hive_repository.dart';

/// Internal implementation used by [HiveManaged]
class HiveManager<E extends HiveObject> {
  static final Map<Type, HiveManager> _managerCache = {};

  /// **Warning:** [hiveInterface] is only changed for
  /// **unit-test purposes** to allow mocking.
  @visibleForTesting
  static HiveInterface hiveInterface = Hive;

  /// **Warning:** [hiveRepository] is only changed for
  /// **unit-test purposes** to allow mocking.
  @visibleForTesting
  static HiveRepository hiveRepository = HiveManagedRepository;

  void _checkInstanceOnNull(HiveObjectReference<E> instance) {
    if (instance.hiveObject == null) {
      throw HiveManagedError(
          'Cannot work with empty/null instance of $E in $HiveObjectReference');
    }
  }

  dynamic _getValidIdOrThrow(E instance) {
    final id = getId(instance);
    if (id == null) {
      throw HiveManagedError(
          'Instance of $E is not in a box. Id of the object is null.'
          'Valid Id is required for all operations');
    }

    return id;
  }

  /// See [HiveManaged.getId()]
  dynamic getId(E instance) {
    assert(instance != null);

    if (instance is! IKey) {
      throw HiveManagedError(
          'Unable to get Id because $E does not implement $IKey');
    }

    return (instance as IKey).managedKey;
  }

  /// See [HiveManaged.getBox()]
  Future<Box<E>> getBox() async {
    return hiveInterface.openBox(hiveRepository.getBoxName<E>());
  }

  Future<void> _put(E instance) async =>
      (await getBox()).put(getId(instance), instance);

  Future<E> _get(dynamic key) async => (await getBox()).get(key);

  /// See [HiveManaged.ensure()]
  Future<void> ensure(HiveObjectReference<E> instance) async {
    assert(instance != null);

    _checkInstanceOnNull(instance);

    instance.hiveObject = await ensureObject(instance.hiveObject);
  }

  /// See [HiveManaged.ensureObject()]
  Future<E> ensureObject(E instance) async {
    assert(instance != null);

    if (!instance.isInBox || !(instance.box?.isOpen ?? false)) {
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

  /// See [HiveManaged.getValue()]
  Future<R> getValue<R>(
      HiveObjectReference<E> hiveInstance, Future<R> Function(E) getValue,
      {bool uninsuredGet = false}) async {
    assert(hiveInstance != null);
    assert(getValue != null);

    _checkInstanceOnNull(hiveInstance);

    if (!uninsuredGet) await ensure(hiveInstance);
    return getValue(hiveInstance.hiveObject);
  }

  /// See [HiveManaged.setValue()]
  Future<void> setValue(HiveObjectReference<E> hiveInstance,
      Future<void> Function(E) writeValue) async {
    assert(hiveInstance != null);
    assert(writeValue != null);

    _checkInstanceOnNull(hiveInstance);

    await ensure(hiveInstance);
    await writeValue(hiveInstance.hiveObject);

    return hiveInstance.hiveObject.save();
  }

  /// See [HiveManaged.setReference()]
  Future<R> setReference<R extends HiveObject>(
      HiveObjectReference<E> hiveInstance,
      R reference,
      Future<void> Function(E, R) setReference) async {
    assert(hiveInstance != null);
    assert(setReference != null);

    _checkInstanceOnNull(hiveInstance);

    await ensure(hiveInstance);

    final ensuredReference = (reference != null)
        ? await HiveManager<R>().ensureObject(reference)
        : null;
    await setReference(hiveInstance.hiveObject, ensuredReference);
    await hiveInstance.hiveObject.save();

    return ensuredReference;
  }

  /// See [HiveManaged.getOrUpdateReference()]
  Future<R> getOrUpdateReference<R extends HiveObject>(
      HiveObjectReference<E> hiveInstance,
      Future<R> Function(E) getReference,
      Future<void> Function(E, R) setReference) async {
    assert(hiveInstance != null);
    assert(getReference != null);
    assert(setReference != null);

    return this.setReference(hiveInstance,
        await getReference(hiveInstance.hiveObject), setReference);
  }

  /// See [HiveManaged.initialize()]
  Future<E> initialize(
      HiveObjectReference<E> hiveInstance, E Function() newInstance) async {
    assert(newInstance != null);

    hiveInstance.hiveObject = newInstance();
    _checkInstanceOnNull(hiveInstance);

    await ensure(hiveInstance);
    return hiveInstance.hiveObject;
  }

  /// See [HiveManaged.delete()]
  Future<void> delete(HiveObjectReference<E> hiveInstance) async {
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

  /// Factory constructor for [E]
  factory HiveManager() {
    if (_managerCache.containsKey(E)) {
      return _managerCache[E];
    }

    return _managerCache.putIfAbsent(E, () => HiveManager<E>._internal());
  }
}
