import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hive_managed/example/data/objects/data/entities/project_model.dart';
import 'package:hive_managed/example/data/objects/data/entities/task_model.dart';
import 'common.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Task> {}

@immutable
class TestData {
  final taskBox = 'taskBox';
  final taskAdapter = TaskAdapter();

  final projectBox = 'projectBox';
  final projectAdapter = ProjectAdapter();
}

void main() {
  setUp(() {
    HiveRepository.hiveInterface = MockHive();
  });

  group('HiveRepository', () {
    test('.register() should throw because repsoitory uninitialized', () {
      final testData = TestData();

      expect(
          () => HiveRepository.register<Task>(
              testData.taskBox, testData.taskAdapter),
          throwsHiveManagedError('not initialized'));
    });
    test('.getBoxName() should throw because repsoitory uninitialized', () {
      expect(() => HiveRepository.getBoxName<Task>(),
          throwsHiveManagedError('not initialized'));
    });
    test('.closeBox() should throw because repsoitory uninitialized', () {
      expect(() => HiveRepository.closeBox<Task>(),
          throwsHiveManagedError('not initialized'));
    });

    group('.init()', () {
      test('should initialize repository with path', () async {
        final fakePath = 'doesntmatter';

        HiveRepository.init(fakePath);

        verify(HiveRepository.hiveInterface.init(fakePath));
        expect(HiveRepository.isInitialized, equals(true));
      });
      test('should throw because of double initialization', () {
        expect(() => HiveRepository.init('doesntmatter'),
            throwsHiveManagedError('already initialized'));
      });
    });

    test('.getBoxName() should throw because unregistered', () {
      expect(HiveRepository.isInitialized, equals(true));
      expect(() => HiveRepository.getBoxName<Project>(),
          throwsHiveManagedError('unknown'));
    });
    test('.register() should register project repository', () {
      final testData = TestData();

      expect(HiveRepository.isInitialized, equals(true));

      HiveRepository.register<Project>(
          testData.projectBox, testData.projectAdapter);

      verify(HiveRepository.hiveInterface
          .registerAdapter(testData.projectAdapter));
      expect(HiveRepository.getBoxName<Project>(), equals(testData.projectBox));
    });

    group('.register()', () {
      test('should throw because of double box registration', () {
        final testData = TestData();

        expect(HiveRepository.isInitialized, equals(true));

        expect(
            () => HiveRepository.register<Task>(
                testData.projectBox, testData.taskAdapter),
            throwsHiveManagedError(
                '${testData.projectBox} is already registered'));
      });

      test('should register task repository', () {
        final testData = TestData();

        expect(HiveRepository.isInitialized, equals(true));

        HiveRepository.register<Task>(testData.taskBox, testData.taskAdapter);

        verify(
            HiveRepository.hiveInterface.registerAdapter(testData.taskAdapter));
        expect(HiveRepository.getBoxName<Task>(), equals(testData.taskBox));
      });

      test('should throw because of double type registration', () {
        final testData = TestData();

        expect(HiveRepository.isInitialized, equals(true));

        expect(
            () => HiveRepository.register<Task>(
                testData.taskBox, testData.taskAdapter),
            throwsHiveManagedError('$Task is already registered'));
      });
    });
    group('.closeBox()', () {
      test('should close box', () async {
        final testData = TestData();

        final box = MockBox();

        when(HiveRepository.hiveInterface.isBoxOpen(testData.taskBox))
            .thenReturn(true);
        when(HiveRepository.hiveInterface.box(testData.taskBox))
            .thenReturn(box);

        await HiveRepository.closeBox<Task>();

        verify(HiveRepository.hiveInterface.isBoxOpen(testData.taskBox));
        verify(HiveRepository.hiveInterface.box(testData.taskBox));
        verify(box.close());
      });
    });
  });
}
