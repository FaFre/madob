import 'package:hive_managed/src/hive_manager.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/hive_managed_error.dart';
import 'package:hive_managed/src/entities/hive_object_reference.dart';

class HiveManaged<T extends HiveObject> implements HiveObjectReference<T> {
  @override
  T hiveObject;

  @visibleForTesting
  HiveManager<T> hiveManagerInterface = HiveManager<T>();

  HiveManager<T> get hive => hiveManagerInterface;

  void _throwIfUninitialized() {
    if (hiveObject == null) {
      throw HiveManagedError(
          'No hive instance of $T assigned to execute opertation on');
    }
  }

  dynamic getId() {
    _throwIfUninitialized();
    return hive.getId(hiveObject);
  }

  Future<Box<T>> getBox() async => hive.getBox();

  Future<void> ensureAndModify() async => hive.ensureAndModify(this);

  Future<T> ensureAndReturn() async {
    _throwIfUninitialized();
    return hive.ensureAndReturn(hiveObject);
  }

  Future<R> getValue<R>(Future<R> Function(T) getValue,
      {uninsuredGet = false}) {
    _throwIfUninitialized();
    return hive.getValue(this, getValue, uninsuredGet: uninsuredGet);
  }

  Future<void> setValue(Future<void> Function(T) writeValue) async {
    _throwIfUninitialized();
    return hive.setValue(this, writeValue);
  }

  Future<R> setReference<R extends HiveObject>(
      R reference, Future<void> Function(T, R) setReference) async {
    _throwIfUninitialized();
    return hive.setReference(this, reference, setReference);
  }

  Future<R> getOrUpdateReference<R extends HiveObject>(
      Future<R> Function(T) getReference,
      Future<void> Function(T, R) setReference) async {
    _throwIfUninitialized();
    return hive.getOrUpdateReference(this, getReference, setReference);
  }

  Future<void> delete() async {
    _throwIfUninitialized();
    return hive.delete(this);
  }
}
