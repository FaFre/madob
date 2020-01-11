import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/hive_managed_error.dart';
import 'package:hive_managed/src/entities/hive_object_reference.dart';

class HiveManaged<T extends HiveObject, I extends HiveObjectReference<T>> {
  I _hiveInstance;

  @visibleForTesting
  HiveManager<T> hiveManagerInterface = HiveManager<T>();

  HiveManager<T> get hive => hiveManagerInterface;

  void _throwIfUninitialized() {
    if (_hiveInstance == null) {
      throw HiveManagedError(
          'No hive instance of $I assigned to execute opertation on');
    }
  }

  dynamic getId() {
    _throwIfUninitialized();
    return hive.getId(_hiveInstance.hiveObject);
  }

  Future<Box<T>> getBox() async => hive.getBox();

  Future<void> ensureAndModify() async => hive.ensureAndModify(_hiveInstance);

  Future<T> ensureAndReturn() async {
    _throwIfUninitialized();
    return hive.ensureAndReturn(_hiveInstance.hiveObject);
  }

  Future<R> getValue<R>(Future<R> Function(T) getValue,
      {uninsuredGet = false}) {
    _throwIfUninitialized();
    return hive.getValue(_hiveInstance, getValue, uninsuredGet: uninsuredGet);
  }

  Future<void> setValue(Future<void> Function(T) writeValue) async {
    _throwIfUninitialized();
    return hive.setValue(_hiveInstance, writeValue);
  }

  Future<R> setReference<R extends HiveObject>(
      R reference, Future<void> Function(T, R) setReference) async {
    _throwIfUninitialized();
    return hive.setReference(_hiveInstance, reference, setReference);
  }

  Future<R> getOrUpdateReference<R extends HiveObject>(
      Future<R> Function(T) getReference,
      Future<void> Function(T, R) setReference) async {
    _throwIfUninitialized();
    return hive.getOrUpdateReference(_hiveInstance, getReference, setReference);
  }

  Future<void> delete() async {
    _throwIfUninitialized();
    return hive.delete(_hiveInstance);
  }
}
