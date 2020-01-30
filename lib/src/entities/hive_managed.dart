import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../../hive_managed_error.dart';
import '../hive_manager.dart';
import 'hive_object_reference.dart';

/// Inherit from [HiveManaged] to create a managed object.
class HiveManaged<E extends HiveObject> implements HiveObjectReference<E> {
  /// [hiveObject] is fully managed by [HiveManager].
  ///
  /// **Warning:** [hiveObject] should only be touched by those
  /// who know what they are doing.
  @override
  E hiveObject;

  /// **Warning:** [hiveManagerInterface] is only changed for
  /// **unit-test purposes** to allow mocking.
  @visibleForTesting
  HiveManager<E> hiveManagerInterface = HiveManager<E>();

  /// Gets the reference of the underlying [HiveManager].
  HiveManager<E> get hive => hiveManagerInterface;

  void _throwIfUninitialized() {
    if (hiveObject == null) {
      throw HiveManagedError(
          'No hive instance of $E assigned to execute operation on');
    }
  }

  /// Returns the Id of the managed object.
  ///
  /// The returned [dynamic] is used also used as a **hive-key**.
  /// For Hive <= 1.3.0 the key must be either of type [int] or [String].
  /// This may change with future versions.
  dynamic getId() {
    _throwIfUninitialized();
    return hive.getId(hiveObject);
  }

  /// Returns the associated box for [E].
  Future<Box<E>> getBox() async => hive.getBox();

  /// Ensures that [hiveObject] does have an active
  /// database relation and is synchronized.
  /// **Changes the reference of [hiveObject] if needed**
  ///
  /// It either gets [hiveObject] from the
  /// database (based on matching [getId()]) or
  /// creates a new object with corresponding [getId()] in the database.
  Future<void> ensure() async => hive.ensure(this);

  /// Ensures [hiveObject] and returns the result from passed [getValue].
  ///
  /// If [uninsuredGet] is set to `true` for
  /// e.g. performance reasons, the result
  /// of [getValue()] **may not represent** the current value in the database.
  @protected
  Future<R> getValue<R>(Future<R> Function(E) getValue,
      {bool uninsuredGet = false}) {
    _throwIfUninitialized();
    return hive.getValue(this, getValue, uninsuredGet: uninsuredGet);
  }

  /// Ensures [hiveObject] and sets the value via [writeValue].
  @protected
  Future<void> setValue(Future<void> Function(E) writeValue) async {
    _throwIfUninitialized();
    return hive.setValue(this, writeValue);
  }

  /// Ensures [hiveObject] + [reference] and sets
  /// the reference via [writeValue].
  @protected
  Future<R> setReference<R extends HiveObject>(
      R reference, Future<void> Function(E, R) setReference) async {
    _throwIfUninitialized();
    return hive.setReference(this, reference, setReference);
  }

  /// Ensures [hiveObject] and returns the ensured result of [getReference].
  /// It may updates the ensured reference via [setReference].
  @protected
  Future<R> getOrUpdateReference<R extends HiveObject>(
      Future<R> Function(E) getReference,
      Future<void> Function(E, R) setReference) async {
    _throwIfUninitialized();
    return hive.getOrUpdateReference(this, getReference, setReference);
  }

  /// [initialize()] is mandatory and has to be
  /// called before any other operation.
  Future<E> initialize(E Function() newInstance) {
    return hive.initialize(this, newInstance);
  }

  /// Removes [hiveObject] from the database and sets it's reference to `null`.
  Future<void> delete() async {
    _throwIfUninitialized();
    return hive.delete(this);
  }
}
