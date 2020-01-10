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

  test('get task box', () async {
    var box = await openBox(() => HiveManager<Task>().getBox());

    noMoreInteractions();

    expect(box, isA<Box<Task>>());
  });

  group('get id', () {
    test('get from task', () {
      final id = '1337';
      final task = Task(id);

      var regainedId = HiveManager<Task>().getId(task) as String;

      zeroInteractions();

      expect(regainedId, equals(id));
    });

    test('throw because of wrong object', () {
      final wrongObject = MockHiveObject();

      expect(() => HiveManager<MockHiveObject>().getId(wrongObject),
          throwsHiveManagedError('not implement $IKey'));
    });
  });

  group('ensureAndReturn', () {
    test('return same isInBox', () async {
      final tTask = MockTask();

      when(tTask.isInBox).thenReturn(true);

      final returnedTask = await HiveManager<MockTask>().ensureAndReturn(tTask);

      verify(tTask.isInBox);
      noMoreInteractions();

      expect(returnedTask, equals(tTask));
    });

    test('return via get', () async {
      final tBoxName = 'testBox';
      final tId = '1';
      final tReturnTitle = Future.value('ret');

      final tTask = MockTask();
      final tReturnTask = MockTask();

      final tBox = MockBox<MockTask>();

      when(HiveManager.hiveRepository.getBoxName<MockTask>())
          .thenReturn(tBoxName);
      when(HiveManager.hiveInterface.openBox(tBoxName))
          .thenAnswer((_) => Future<MockBox<MockTask>>.value(tBox));

      when(tTask.managedId).thenReturn(tId);

      when(tBox.get(tId)).thenReturn(tReturnTask);
      when(tReturnTask.title).thenAnswer((_) => tReturnTitle);

      when(tTask.isInBox).thenReturn(false);

      final returnedTask = await HiveManager<MockTask>().ensureAndReturn(tTask);

      verify(HiveManager.hiveRepository.getBoxName<MockTask>());
      verify(HiveManager.hiveInterface.openBox(tBoxName));
      verify(tTask.managedId);
      verify(tBox.get(any));

      noMoreInteractions();

      expect(returnedTask.title, equals(tReturnTitle));
    });

    test('return via put', () async {
      final tBoxName = 'testBox';
      final tId = '1';
      final tTask = MockTask();

      final tBox = MockBox<MockTask>();

      when(HiveManager.hiveRepository.getBoxName<MockTask>())
          .thenReturn(tBoxName);
      when(HiveManager.hiveInterface.openBox(tBoxName))
          .thenAnswer((_) => Future<MockBox<MockTask>>.value(tBox));

      when(tTask.managedId).thenReturn(tId);

      when(tBox.get(tId)).thenReturn(null);

      when(tTask.isInBox).thenReturn(false);

      final returnedTask = await HiveManager<MockTask>().ensureAndReturn(tTask);

      verify(HiveManager.hiveRepository.getBoxName<MockTask>());
      verify(HiveManager.hiveInterface.openBox(tBoxName));
      verify(tTask.managedId);
      verify(tBox.get(any));
      verify(tBox.put(any, any));

      noMoreInteractions();

      expect(returnedTask, equals(tTask));
    });

    test('throw because key is null', () {
      final tTask = MockTask();

      when(tTask.isInBox).thenReturn(false);
      when(tTask.managedId).thenReturn(null);

      expect(() => HiveManager<MockTask>().ensureAndReturn(tTask),
          throwsHiveManagedError('null'));

      zeroInteractions();
    });
  });

  group('ensureAndModify', () {
    test('should thrown because of HiveObject null', () {
      final tReference = ManagedTask();

      expect(() => HiveManager<Task>().ensureAndModify(tReference),
          throwsHiveManagedError('null'));

      zeroInteractions();
    });

    test('modify returned obj from ensureAndModify', () async {
      final tBoxName = 'testBox';
      final tId = '1';
      final tTask = MockTask();
      final tReturnedTask = MockTask();
      final tTaskInstance = MockManagedTask();

      final tBox = MockBox<MockTask>();

      when(HiveManager.hiveRepository.getBoxName<MockTask>())
          .thenReturn(tBoxName);
      when(HiveManager.hiveInterface.openBox(tBoxName))
          .thenAnswer((_) => Future<MockBox<MockTask>>.value(tBox));

      when(tTaskInstance.hiveObject).thenReturn(tTask);
      when(tTask.managedId).thenReturn(tId);

      when(tBox.get(tId)).thenReturn(tReturnedTask);

      when(tTask.isInBox).thenReturn(false);

      await HiveManager<MockTask>().ensureAndModify(tTaskInstance);

      verify(HiveManager.hiveRepository.getBoxName<MockTask>());
      verify(HiveManager.hiveInterface.openBox(tBoxName));
      verify(tTask.managedId);
      verify(tBox.get(any));
      verify(tTaskInstance.hiveObject = tReturnedTask);

      noMoreInteractions();
    });
  });
}
