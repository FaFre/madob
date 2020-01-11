import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/entities/hive_object_reference.dart';
import 'package:hive_managed/src/entities/key.dart';
import 'package:hive_managed/src/managed/hive_managed.dart';
import 'package:hive_managed/src/managed/hive_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hive_managed/src/repositories/hive_repository.dart';
import '../data/objects/data/entities/managed_task_model.dart';
import '../data/objects/data/entities/task_model.dart';
import '../data/objects/domain/entities/task.dart';
import 'common.dart';

class MockHive extends Mock implements HiveInterface {}

class MockRepository extends Mock implements HiveRepositoryImplementation {}

class MockBox<T> extends Mock implements Box<T> {}

class MockHiveObject extends Mock implements HiveObject {}

class MockTask extends Mock implements Task {}

class MockManagedTask extends Mock
    implements
        HiveManaged<MockTask, MockManagedTask>,
        ITask,
        HiveObjectReference<MockTask> {}

class EnsuredTest {
  final tBoxName = 'testBox';
  final tId = '1';
  final tTask = MockTask();
  final tReturnedTask = MockTask();
  final tReturnedTaskTitle = 'Returned Title';
  final tTaskInstance = MockManagedTask();

  final tBox = MockBox<MockTask>();

  EnsuredTest() {
    when(HiveManager.hiveRepository.getBoxName<MockTask>())
        .thenReturn(tBoxName);
    when(HiveManager.hiveInterface.openBox(tBoxName))
        .thenAnswer((_) => Future<MockBox<MockTask>>.value(tBox));

    when(tTask.isInBox).thenReturn(false);
    when(tTask.managedId).thenReturn(tId);

    when(tReturnedTask.isInBox).thenReturn(true);
    when(tReturnedTask.managedId).thenReturn(tId);
    when(tReturnedTask.title)
        .thenAnswer((_) => Future.value(tReturnedTaskTitle));

    when(tTaskInstance.hiveObject).thenReturn(tTask);
    when(tBox.get(tId)).thenReturn(tReturnedTask);
  }

  Future<void> run(Future Function() func, {doVerification = true}) async {
    await func();

    if (doVerification) {
      verify(HiveManager.hiveRepository.getBoxName<MockTask>());
      verify(HiveManager.hiveInterface.openBox(tBoxName));
      verify(tTask.managedId);
      verify(tBox.get(any));
    }
  }
}

void main() {
  setUp(() {
    HiveManager.hiveInterface = MockHive();
    HiveManager.hiveRepository = MockRepository();
  });

  void noMoreInteractions() {
    verifyNoMoreInteractions(HiveManager.hiveInterface);
    verifyNoMoreInteractions(HiveManager.hiveRepository);
  }

  void zeroInteractions() {
    verifyZeroInteractions(HiveManager.hiveInterface);
    verifyZeroInteractions(HiveManager.hiveRepository);
  }

  Future<Box<T>> openBox<T extends HiveObject>(
      Future<Box<T>> Function() func) async {
    final tBox = 'testBox';

    when(HiveManager.hiveRepository.getBoxName<Task>()).thenReturn(tBox);
    when(HiveManager.hiveInterface.openBox(tBox))
        .thenAnswer((_) => Future<MockBox<Task>>.value(MockBox<Task>()));

    final box = func();

    verify(HiveManager.hiveRepository.getBoxName<Task>());
    verify(HiveManager.hiveInterface.openBox(tBox));

    return box;
  }

  test('should get task box', () async {
    var box = await openBox(() => HiveManager<Task>().getBox());

    noMoreInteractions();

    expect(box, isA<Box<Task>>());
  });

  group('get id', () {
    test('should get id from task', () {
      final id = '1337';
      final task = Task(id);

      var regainedId = HiveManager<Task>().getId(task) as String;

      zeroInteractions();

      expect(regainedId, equals(id));
    });

    test('should throw because of wrong object', () {
      final wrongObject = MockHiveObject();

      expect(() => HiveManager<MockHiveObject>().getId(wrongObject),
          throwsHiveManagedError('not implement $IKey'));
    });
  });

  group('ensureAndReturn', () {
    test('should return same isInBox', () async {
      final tTask = MockTask();

      when(tTask.isInBox).thenReturn(true);

      final returnedTask = await HiveManager<MockTask>().ensureAndReturn(tTask);

      verify(tTask.isInBox);

      noMoreInteractions();

      expect(returnedTask, equals(tTask));
    });

    test('should return via get', () async {
      MockTask returnedTask;

      final ensuredTest = EnsuredTest();
      await ensuredTest.run(() async => returnedTask =
          await HiveManager<MockTask>().ensureAndReturn(ensuredTest.tTask));

      noMoreInteractions();

      expect(await returnedTask.title, equals(ensuredTest.tReturnedTaskTitle));
    });

    test('should return via put', () async {
      final tBoxName = 'testBox';
      final tId = '1';
      final tTask = MockTask();

      final tBox = MockBox<MockTask>();

      when(HiveManager.hiveRepository.getBoxName<MockTask>())
          .thenReturn(tBoxName);
      when(HiveManager.hiveInterface.openBox(tBoxName))
          .thenAnswer((_) => Future<MockBox<MockTask>>.value(tBox));

      when(tTask.isInBox).thenReturn(false);
      when(tTask.managedId).thenReturn(tId);

      when(tBox.get(tId)).thenReturn(null);

      final returnedTask = await HiveManager<MockTask>().ensureAndReturn(tTask);

      verify(HiveManager.hiveRepository.getBoxName<MockTask>());
      verify(HiveManager.hiveInterface.openBox(tBoxName));
      verify(tTask.managedId);
      verify(tBox.get(tId));
      verify(tBox.put(tId, tTask));

      noMoreInteractions();

      expect(returnedTask, equals(tTask));
    });

    test('should throw because key is null', () {
      final tTask = MockTask();

      when(tTask.isInBox).thenReturn(false);
      when(tTask.managedId).thenReturn(null);

      zeroInteractions();

      expect(() => HiveManager<MockTask>().ensureAndReturn(tTask),
          throwsHiveManagedError('null'));
    });
  });

  group('ensureAndModify', () {
    test('should thrown because of HiveObject null', () {
      final tReference = ManagedTask();

      expect(() => HiveManager<Task>().ensureAndModify(tReference),
          throwsHiveManagedError('null'));

      zeroInteractions();
    });

    test('should modify returned obj from ensureAndModify', () async {
      final ensuredTest = EnsuredTest();
      await ensuredTest.run(() async => await HiveManager<MockTask>()
          .ensureAndModify(ensuredTest.tTaskInstance));

      verify(ensuredTest.tTaskInstance.hiveObject = ensuredTest.tReturnedTask);

      noMoreInteractions();
    });
  });

  group('get', () {
    test('should get ensured', () async {
      final returnValue = 1;
      var calledInstance;
      var callReturnValue;

      var ensuredTest = EnsuredTest();
      await ensuredTest.run(() async {
        callReturnValue = await HiveManager<MockTask>()
            .getValue<int>(ensuredTest.tTaskInstance, (instance) async {
          calledInstance = instance;
          return returnValue;
        });
      });

      verify(ensuredTest.tTaskInstance.hiveObject = ensuredTest.tReturnedTask);

      expect(calledInstance, equals(ensuredTest.tTaskInstance.hiveObject));
      expect(callReturnValue, equals(returnValue));

      noMoreInteractions();
    });

    test('should get uninsured', () async {
      final returnValue = 1;
      var calledInstance;

      final ensuredTest = EnsuredTest();
      when(ensuredTest.tTaskInstance.hiveObject).thenReturn(ensuredTest.tTask);

      var callReturnValue = await HiveManager<MockTask>()
          .getValue<int>(ensuredTest.tTaskInstance, (instance) async {
        calledInstance = instance;
        return returnValue;
      }, uninsuredGet: true);

      zeroInteractions();

      expect(calledInstance, equals(ensuredTest.tTaskInstance.hiveObject));
      expect(callReturnValue, equals(returnValue));
    });

    test('should throw object null', () async {
      final instance = MockManagedTask();

      expect(
          () async =>
              await HiveManager<MockTask>().getValue<int>(instance, (_) async {
                return null;
              }),
          throwsHiveManagedError('null'));
    });
  });

  group('set', () {
    test('should set value', () async {
      var calledInstance;

      final ensuredTest = EnsuredTest();
      when(ensuredTest.tTask.save()).thenAnswer((_) => Future.value());

      await ensuredTest.run(() async => await HiveManager<MockTask>().setValue(
          ensuredTest.tTaskInstance,
          (instance) async => calledInstance = instance));

      verify(ensuredTest.tTask.save());

      noMoreInteractions();

      expect(calledInstance, equals(ensuredTest.tTaskInstance.hiveObject));
    });

    test('should throw object null', () async {
      final instance = MockManagedTask();

      expect(
          () async =>
              await HiveManager<MockTask>().setValue(instance, (_) async {
                return null;
              }),
          throwsHiveManagedError('null'));
    });
  });

  group('set reference', () {
    test('should throw object null', () async {
      final instance = MockManagedTask();

      expect(
          () async => await HiveManager<MockTask>().setReference(instance, null,
                  (i, v) async {
                return null;
              }),
          throwsHiveManagedError('null'));
    });
    test('set empty reference', () async {
      final ensuredTest = EnsuredTest();

      var setterCalled = false;
      MockTask returendInstance;

      await ensuredTest.run(() async {
        returendInstance = await HiveManager<MockTask>().setReference<MockTask>(
            ensuredTest.tTaskInstance, null, (instance, val) async {
          setterCalled = true;
        });
      });

      noMoreInteractions();

      expect(setterCalled, equals(false));
      expect(returendInstance, equals(null));
    });

    test('set reference', () async {
      final ensuredTest = EnsuredTest();

      var setterCalled = false;
      MockTask returendInstance;
      MockTask settedValue;
      MockTask settedInstance;

      await ensuredTest.run(() async {
        returendInstance = await HiveManager<MockTask>().setReference<MockTask>(
            ensuredTest.tTaskInstance, ensuredTest.tTask,
            (instance, val) async {
          settedValue = val;
          settedInstance = instance;
          setterCalled = true;
        });
      }, doVerification: false);

      verify(HiveManager.hiveRepository.getBoxName<MockTask>()).called(2);
      verify(HiveManager.hiveInterface.openBox(ensuredTest.tBoxName)).called(2);
      verify(ensuredTest.tTask.managedId).called(2);
      verify(ensuredTest.tBox.get(any)).called(2);
      verify(ensuredTest.tTask.save());

      expect(setterCalled, equals(true));
      expect(returendInstance, equals(ensuredTest.tReturnedTask));
      expect(settedValue, equals(ensuredTest.tReturnedTask));
      expect(settedInstance, equals(ensuredTest.tTaskInstance.hiveObject));
    });
  });

  group('get or update reference', () {
    test('should throw object null', () async {
      final instance = MockManagedTask();

      expect(
          () async => await HiveManager<MockTask>().getOrUpdateReference(
                  instance, (_) async => null, (i, v) async {
                return null;
              }),
          throwsHiveManagedError('null'));
    });

    test('set reference', () async {
      final ensuredTest = EnsuredTest();

      var getterCalled = false;
      var setterCalled = false;
      MockTask returendInstance;
      MockTask settedValue;
      MockTask getterInstance;
      MockTask settedInstance;

      await ensuredTest.run(() async {
        returendInstance = await HiveManager<MockTask>()
            .getOrUpdateReference<MockTask>(ensuredTest.tTaskInstance,
                (instance) async {
          getterCalled = true;
          getterInstance = instance;
          return ensuredTest.tTask;
        }, (instance, val) async {
          settedValue = val;
          settedInstance = instance;
          setterCalled = true;
        });
      }, doVerification: false);

      verify(HiveManager.hiveRepository.getBoxName<MockTask>()).called(2);
      verify(HiveManager.hiveInterface.openBox(ensuredTest.tBoxName)).called(2);
      verify(ensuredTest.tTask.managedId).called(2);
      verify(ensuredTest.tBox.get(any)).called(2);
      verify(ensuredTest.tTask.save());

      expect(getterCalled, equals(true));
      expect(setterCalled, equals(true));
      expect(returendInstance, equals(ensuredTest.tReturnedTask));
      expect(settedValue, equals(ensuredTest.tReturnedTask));
      expect(getterInstance, equals(ensuredTest.tTaskInstance.hiveObject));
      expect(settedInstance, equals(ensuredTest.tTaskInstance.hiveObject));
    });
  });
}
