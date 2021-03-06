import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:madob/src/entities/key.dart';
import 'package:madob/src/hive_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:madob_example/data/objects/task.dart';

import '../helper/common.dart';
import '../helper/mocking.dart';

@immutable
class TestData {
  final String tBoxName = 'testBox';
  final String tId = '1';
  final MockTask tTask = MockTask();
  final MockTask tReturnedTask = MockTask();
  final String tReturnedTaskTitle = 'Returned Title';
  final MockManagedTask tTaskInstance = MockManagedTask();

  final MockBox<MockTask> tBox = MockBox<MockTask>();
}

class EnsuredTest {
  final TestData testData;

  EnsuredTest() : testData = TestData() {
    when(HiveManager.boxRepository.getBoxName<MockTask>())
        .thenReturn(testData.tBoxName);
    when(HiveManager.hiveInterface.openBox(testData.tBoxName))
        .thenAnswer((_) => Future<MockBox<MockTask>>.value(testData.tBox));

    when(testData.tTask.isInBox).thenReturn(false);
    when(testData.tTask.box).thenReturn(testData.tBox);
    when(testData.tBox.isOpen).thenReturn(true);
    when(testData.tTask.managedKey).thenReturn(testData.tId);

    when(testData.tReturnedTask.isInBox).thenReturn(true);
    when(testData.tReturnedTask.managedKey).thenReturn(testData.tId);
    when(testData.tReturnedTask.title)
        .thenAnswer((_) => Future.value(testData.tReturnedTaskTitle));

    when(testData.tTaskInstance.hiveObject).thenReturn(testData.tTask);
    when(testData.tBox.get(testData.tId)).thenReturn(testData.tReturnedTask);
  }

  Future<void> run(Future Function() func, {bool doVerification = true}) async {
    await func();

    if (doVerification) {
      verify(HiveManager.boxRepository.getBoxName<MockTask>());
      verify(HiveManager.hiveInterface.openBox(testData.tBoxName));
      verify(testData.tTask.managedKey);
      verify(testData.tBox.get(any));
    }
  }
}

void main() {
  setUp(() {
    HiveManager.hiveInterface = MockHive();
    HiveManager.boxRepository = MockBoxRepository();
  });

  void noMoreInteractions() {
    verifyNoMoreInteractions(HiveManager.hiveInterface);
    verifyNoMoreInteractions(HiveManager.boxRepository);
  }

  void zeroInteractions() {
    verifyZeroInteractions(HiveManager.hiveInterface);
    verifyZeroInteractions(HiveManager.boxRepository);
  }

  Future<Box<T>> openBox<T extends HiveObject>(
      Future<Box<T>> Function() func) async {
    final tBox = 'testBox';

    when(HiveManager.boxRepository.getBoxName<Task>()).thenReturn(tBox);
    when(HiveManager.hiveInterface.openBox(tBox))
        .thenAnswer((_) => Future<MockBox<Task>>.value(MockBox<Task>()));

    final box = func();

    verify(HiveManager.boxRepository.getBoxName<Task>());
    verify(HiveManager.hiveInterface.openBox(tBox));

    noMoreInteractions();

    return box;
  }

  group('HiveManager', () {
    test('.getBox() should get task box', () async {
      final box = await openBox(() => HiveManager<Task>().getBox());

      noMoreInteractions();

      expect(box, isA<Box<Task>>());
    });

    group('.getId()', () {
      test('should get id from task', () {
        final id = '1337';
        final task = Task(id);

        final regainedId = HiveManager<Task>().getId(task) as String;

        zeroInteractions();

        expect(regainedId, equals(id));
      });

      test('should throw because of wrong object', () {
        final wrongObject = MockHiveObject();

        expect(() => HiveManager<MockHiveObject>().getId(wrongObject),
            throwsMadobError('not implement $IKey'));

        zeroInteractions();
      });
    });

    group('.ensureAndReturn()', () {
      test('should return same isInBox', () async {
        final testData = TestData();

        when(testData.tTask.isInBox).thenReturn(true);
        when(testData.tTask.box).thenReturn(testData.tBox);
        when(testData.tBox.isOpen).thenReturn(true);

        final returnedTask =
            await HiveManager<MockTask>().ensureObject(testData.tTask);

        verify(testData.tTask.isInBox);

        noMoreInteractions();

        expect(returnedTask, same(testData.tTask));
      });

      test('should return via get (not in box)', () async {
        MockTask returnedTask;

        final ensuredTest = EnsuredTest();
        await ensuredTest.run(() async => returnedTask =
            await HiveManager<MockTask>()
                .ensureObject(ensuredTest.testData.tTask));

        noMoreInteractions();

        expect(await returnedTask.title,
            equals(ensuredTest.testData.tReturnedTaskTitle));
      });

      test('should return via put', () async {
        final testData = TestData();

        when(HiveManager.boxRepository.getBoxName<MockTask>())
            .thenReturn(testData.tBoxName);
        when(HiveManager.hiveInterface.openBox(testData.tBoxName))
            .thenAnswer((_) => Future<MockBox<MockTask>>.value(testData.tBox));

        when(testData.tTask.isInBox).thenReturn(false);
        when(testData.tTask.managedKey).thenReturn(testData.tId);

        when(testData.tBox.get(testData.tId)).thenReturn(null);

        final returnedTask =
            await HiveManager<MockTask>().ensureObject(testData.tTask);

        verify(HiveManager.boxRepository.getBoxName<MockTask>());
        verify(HiveManager.hiveInterface.openBox(testData.tBoxName));
        verify(testData.tTask.managedKey);
        verify(testData.tBox.get(testData.tId));
        verify(testData.tBox.put(testData.tId, testData.tTask));

        noMoreInteractions();

        expect(returnedTask, same(testData.tTask));
      });

      test('should return via get (box closed)', () async {
        final testData = TestData();

        when(HiveManager.boxRepository.getBoxName<MockTask>())
            .thenReturn(testData.tBoxName);
        when(HiveManager.hiveInterface.openBox(testData.tBoxName))
            .thenAnswer((_) => Future<MockBox<MockTask>>.value(testData.tBox));

        when(testData.tTask.isInBox).thenReturn(true);
        when(testData.tTask.box).thenReturn(testData.tBox);
        when(testData.tBox.isOpen).thenReturn(false);
        when(testData.tTask.managedKey).thenReturn(testData.tId);

        when(testData.tReturnedTask.isInBox).thenReturn(true);
        when(testData.tReturnedTask.managedKey).thenReturn(testData.tId);
        when(testData.tReturnedTask.title)
            .thenAnswer((_) => Future.value(testData.tReturnedTaskTitle));

        when(testData.tTaskInstance.hiveObject).thenReturn(testData.tTask);
        when(testData.tBox.get(testData.tId))
            .thenReturn(testData.tReturnedTask);

        final returnedTask =
            await HiveManager<MockTask>().ensureObject(testData.tTask);

        verify(HiveManager.boxRepository.getBoxName<MockTask>());
        verify(HiveManager.hiveInterface.openBox(testData.tBoxName));
        verify(testData.tTask.managedKey);
        verify(testData.tBox.get(any));

        noMoreInteractions();

        expect(returnedTask, same(testData.tReturnedTask));
      });

      test('should throw because key is null', () {
        final testData = TestData();

        when(testData.tTask.isInBox).thenReturn(false);
        when(testData.tTask.managedKey).thenReturn(null);

        zeroInteractions();

        expect(() => HiveManager<MockTask>().ensureObject(testData.tTask),
            throwsMadobError('null'));
      });
    });

    group('.ensureAndModify()', () {
      test('should thrown because of HiveObject null', () {
        final testData = TestData();

        zeroInteractions();

        expect(() => HiveManager<Task>().ensure(testData.tTaskInstance),
            throwsMadobError('null'));
      });

      test('should modify returned obj from ensureAndModify', () async {
        final ensuredTest = EnsuredTest();
        await ensuredTest.run(() async => await HiveManager<MockTask>()
            .ensure(ensuredTest.testData.tTaskInstance));

        verify(ensuredTest.testData.tTaskInstance.hiveObject =
            ensuredTest.testData.tReturnedTask);

        noMoreInteractions();
      });
    });

    group('.get()', () {
      test('should get value ensured', () async {
        final returnValue = 1;
        var calledInstance;
        var callReturnValue;

        var ensuredTest = EnsuredTest();
        await ensuredTest.run(() async {
          callReturnValue = await HiveManager<MockTask>().getValue<int>(
              ensuredTest.testData.tTaskInstance, (instance) async {
            calledInstance = instance;
            return returnValue;
          });
        });

        verify(ensuredTest.testData.tTaskInstance.hiveObject =
            ensuredTest.testData.tReturnedTask);

        noMoreInteractions();

        expect(calledInstance,
            same(ensuredTest.testData.tTaskInstance.hiveObject));
        expect(callReturnValue, equals(returnValue));
      });

      test('should get value uninsured', () async {
        final returnValue = 1;
        var calledInstance;

        final ensuredTest = EnsuredTest();
        when(ensuredTest.testData.tTaskInstance.hiveObject)
            .thenReturn(ensuredTest.testData.tTask);

        var callReturnValue = await HiveManager<MockTask>().getValue<int>(
            ensuredTest.testData.tTaskInstance, (instance) async {
          calledInstance = instance;
          return returnValue;
        }, uninsuredGet: true);

        zeroInteractions();

        expect(calledInstance,
            same(ensuredTest.testData.tTaskInstance.hiveObject));
        expect(callReturnValue, equals(returnValue));
      });

      test('should throw object null', () async {
        final instance = MockManagedTask();

        await expectLater(
            HiveManager<MockTask>().getValue<int>(instance, (_) async {
              return null;
            }),
            throwsMadobError('null'));

        zeroInteractions();
      });
    });

    group('.set()', () {
      test('should set value', () async {
        var calledInstance;

        final ensuredTest = EnsuredTest();
        when(ensuredTest.testData.tTask.save())
            .thenAnswer((_) => Future.value());

        await ensuredTest.run(() async => await HiveManager<MockTask>()
            .setValue(ensuredTest.testData.tTaskInstance,
                (instance) async => calledInstance = instance));

        verify(ensuredTest.testData.tTask.save());

        noMoreInteractions();

        expect(calledInstance,
            same(ensuredTest.testData.tTaskInstance.hiveObject));
      });

      test('should thrown because of HiveObject null', () async {
        final testData = TestData();

        when(testData.tTaskInstance.hiveObject).thenReturn(null);

        await expectLater(
            HiveManager<MockTask>().setValue(testData.tTaskInstance, (_) async {
              return null;
            }),
            throwsMadobError('null'));

        zeroInteractions();
      });
    });

    group('.setReference()', () {
      test('should thrown because of HiveObject null', () async {
        final testData = TestData();

        await expectLater(
            HiveManager<MockTask>().setReference(testData.tTaskInstance, null,
                (i, v) async {
              return null;
            }),
            throwsMadobError('null'));

        zeroInteractions();
      });
      test('should set empty reference', () async {
        final ensuredTest = EnsuredTest();

        var setterCalled = false;
        MockTask returendInstance;

        await ensuredTest.run(() async {
          returendInstance = await HiveManager<MockTask>()
              .setReference<MockTask>(ensuredTest.testData.tTaskInstance, null,
                  (instance, val) async {
            setterCalled = true;
          });
        });

        noMoreInteractions();

        expect(setterCalled, equals(true));
        expect(returendInstance, equals(null));
      });

      test('should set reference', () async {
        final ensuredTest = EnsuredTest();

        var setterCalled = false;
        MockTask returendInstance;
        MockTask settedValue;
        MockTask settedInstance;

        await ensuredTest.run(() async {
          returendInstance = await HiveManager<MockTask>()
              .setReference<MockTask>(ensuredTest.testData.tTaskInstance,
                  ensuredTest.testData.tTask, (instance, val) async {
            settedValue = val;
            settedInstance = instance;
            setterCalled = true;
          });
        }, doVerification: false);

        verify(HiveManager.boxRepository.getBoxName<MockTask>()).called(2);
        verify(HiveManager.hiveInterface.openBox(ensuredTest.testData.tBoxName))
            .called(2);
        verify(ensuredTest.testData.tTask.managedKey).called(2);
        verify(ensuredTest.testData.tBox.get(any)).called(2);
        verify(ensuredTest.testData.tTask.save());

        noMoreInteractions();

        expect(setterCalled, equals(true));
        expect(returendInstance, same(ensuredTest.testData.tReturnedTask));
        expect(settedValue, same(ensuredTest.testData.tReturnedTask));
        expect(settedInstance,
            same(ensuredTest.testData.tTaskInstance.hiveObject));
      });
    });

    group('.getOrUpdateReference()', () {
      test('should thrown because of HiveObject null', () async {
        final testData = TestData();

        when(testData.tTaskInstance.hiveObject).thenReturn(null);

        await expectLater(
            HiveManager<MockTask>().getOrUpdateReference(
                testData.tTaskInstance, (_) async => null, (i, v) async {
              return null;
            }),
            throwsMadobError('null'));
      });

      test('should update reference', () async {
        final ensuredTest = EnsuredTest();

        var getterCalled = false;
        var setterCalled = false;
        MockTask returendInstance;
        MockTask settedValue;
        MockTask getterInstance;
        MockTask settedInstance;

        await ensuredTest.run(() async {
          returendInstance = await HiveManager<MockTask>()
              .getOrUpdateReference<MockTask>(
                  ensuredTest.testData.tTaskInstance, (instance) async {
            getterCalled = true;
            getterInstance = instance;
            return ensuredTest.testData.tTask;
          }, (instance, val) async {
            settedValue = val;
            settedInstance = instance;
            setterCalled = true;
          });
        }, doVerification: false);

        verify(HiveManager.boxRepository.getBoxName<MockTask>()).called(2);
        verify(HiveManager.hiveInterface.openBox(ensuredTest.testData.tBoxName))
            .called(2);
        verify(ensuredTest.testData.tTask.managedKey).called(2);
        verify(ensuredTest.testData.tBox.get(any)).called(2);
        verify(ensuredTest.testData.tTask.save());

        noMoreInteractions();

        expect(getterCalled, equals(true));
        expect(setterCalled, equals(true));
        expect(returendInstance, same(ensuredTest.testData.tReturnedTask));
        expect(settedValue, equals(ensuredTest.testData.tReturnedTask));
        expect(getterInstance,
            same(ensuredTest.testData.tTaskInstance.hiveObject));
        expect(settedInstance,
            same(ensuredTest.testData.tTaskInstance.hiveObject));
      });
    });

    group('.initialize()', () {
      test('should create new instance and ensures it', () async {
        final testData = TestData();

        var calledInstance = false;
        MockTask createInstance() {
          calledInstance = true;
          return testData.tTask;
        }

        when(testData.tTaskInstance.hiveObject).thenReturn(testData.tTask);
        when(testData.tTask.isInBox).thenReturn(true);
        when(testData.tTask.box).thenReturn(testData.tBox);
        when(testData.tBox.isOpen).thenReturn(true);

        expect(
            await HiveManager<MockTask>()
                .initialize(testData.tTaskInstance, createInstance),
            equals(testData.tTaskInstance.hiveObject));

        verify(testData.tTaskInstance.hiveObject = testData.tTask);

        noMoreInteractions();

        expect(calledInstance, isTrue);
      });

      test('should throw because createInstance returns null', () async {
        final testData = TestData();

        var calledInstance = false;
        MockTask createInstance() {
          calledInstance = true;
          return null;
        }

        when(testData.tTaskInstance.hiveObject).thenReturn(null);

        await expectLater(
            HiveManager<MockTask>()
                .initialize(testData.tTaskInstance, createInstance),
            throwsMadobError('null'));

        verify(testData.tTaskInstance.hiveObject = null);

        noMoreInteractions();

        expect(calledInstance, isTrue);
      });
    });

    group('.delete()', () {
      test('should thrown because of HiveObject null', () async {
        final testData = TestData();

        when(testData.tTaskInstance.hiveObject).thenReturn(null);

        await expectLater(
            HiveManager<MockTask>().delete(testData.tTaskInstance),
            throwsMadobError('null'));

        zeroInteractions();
      });

      test('should throw because id is not in box', () async {
        final testData = TestData();

        when(HiveManager.boxRepository.getBoxName<MockTask>())
            .thenReturn(testData.tBoxName);
        when(HiveManager.hiveInterface.openBox(testData.tBoxName))
            .thenAnswer((_) => Future<MockBox<MockTask>>.value(testData.tBox));

        when(testData.tTask.isInBox).thenReturn(false);
        when(testData.tTask.managedKey).thenReturn(testData.tId);

        when(testData.tTaskInstance.hiveObject).thenReturn(testData.tTask);
        when(testData.tBox.get(testData.tId)).thenReturn(null);

        await expectLater(
            HiveManager<MockTask>().delete(testData.tTaskInstance),
            throwsMadobError('Cannot delete'));

        verify(HiveManager.boxRepository.getBoxName<MockTask>());
        verify(HiveManager.hiveInterface.openBox(testData.tBoxName));
        verify(testData.tTask.managedKey);

        noMoreInteractions();
      });

      test('should delete task is not in box yet', () async {
        final testData = TestData();

        when(HiveManager.boxRepository.getBoxName<MockTask>())
            .thenReturn(testData.tBoxName);
        when(HiveManager.hiveInterface.openBox(testData.tBoxName))
            .thenAnswer((_) => Future<MockBox<MockTask>>.value(testData.tBox));

        when(testData.tTask.isInBox).thenReturn(false);
        when(testData.tTask.managedKey).thenReturn(testData.tId);

        when(testData.tTaskInstance.hiveObject).thenReturn(testData.tTask);
        when(testData.tBox.get(testData.tId))
            .thenReturn(testData.tReturnedTask);

        await HiveManager<MockTask>().delete(testData.tTaskInstance);

        verify(HiveManager.boxRepository.getBoxName<MockTask>());
        verify(HiveManager.hiveInterface.openBox(testData.tBoxName));
        verify(testData.tTask.managedKey);
        verify(testData.tBox.get(testData.tId));
        verify(testData.tTaskInstance.hiveObject = testData.tReturnedTask);
        verify(testData.tTask.delete());
        verify(testData.tTaskInstance.hiveObject = null);

        noMoreInteractions();
      });

      test('should delete task that is already in box', () async {
        final testData = TestData();

        when(testData.tTaskInstance.hiveObject).thenReturn(testData.tTask);
        when(testData.tTask.isInBox).thenReturn(true);

        await HiveManager<MockTask>().delete(testData.tTaskInstance);

        verify(testData.tTask.delete());
        verify(testData.tTaskInstance.hiveObject = null);

        noMoreInteractions();
      });
    });
  });
}
