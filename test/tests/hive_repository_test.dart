import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hive_managed_example/data/objects/data/entities/project_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/task_model.dart';
import 'common.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Task> {}

@immutable
class TestData {
  final String taskBox = 'taskBox';
  final TaskAdapter taskAdapter = TaskAdapter();

  final String projectBox = 'projectBox';
  final ProjectAdapter projectAdapter = ProjectAdapter();
}

void main() {
  setUp(() {
    HiveManagedRepository.hiveInterface = MockHive();
  });

  group('HiveRepository', () {
    test('.register() should throw because repository uninitialized', () {
      final testData = TestData();

      expect(
          () => HiveManagedRepository.register<Task>(
              testData.taskBox, testData.taskAdapter),
          throwsHiveManagedError('not initialized'));
    });
    test('.getBoxName() should throw because repository uninitialized', () {
      expect(HiveManagedRepository.getBoxName,
          throwsHiveManagedError('not initialized'));
    });
    test('.closeBox() should throw because repository uninitialized', () {
      expect(HiveManagedRepository.closeBox,
          throwsHiveManagedError('not initialized'));
    });

    group('.init()', () {
      test('should initialize repository with path', () async {
        final fakePath = 'doesntmatter';

        HiveManagedRepository.init(fakePath);

        verify(HiveManagedRepository.hiveInterface.init(fakePath));
        expect(HiveManagedRepository.isInitialized, equals(true));
      });
      test('should throw because of double initialization', () {
        expect(() => HiveManagedRepository.init('doesntmatter'),
            throwsHiveManagedError('already initialized'));
      });
    });

    test('.getBoxName() should throw because unregistered', () {
      expect(HiveManagedRepository.isInitialized, equals(true));
      expect(
          HiveManagedRepository.getBoxName, throwsHiveManagedError('unknown'));
    });
    test('.register() should register project repository', () {
      final testData = TestData();

      expect(HiveManagedRepository.isInitialized, equals(true));

      HiveManagedRepository.register<Project>(
          testData.projectBox, testData.projectAdapter);

      verify(HiveManagedRepository.hiveInterface
          .registerAdapter(testData.projectAdapter));
      expect(HiveManagedRepository.getBoxName<Project>(),
          equals(testData.projectBox));
    });

    group('.register()', () {
      test('should throw because of double box registration', () {
        final testData = TestData();

        expect(HiveManagedRepository.isInitialized, equals(true));

        expect(
            () => HiveManagedRepository.register<Task>(
                testData.projectBox, testData.taskAdapter),
            throwsHiveManagedError(
                '${testData.projectBox} is already registered'));
      });

      test('should register task repository', () {
        final testData = TestData();

        expect(HiveManagedRepository.isInitialized, equals(true));

        HiveManagedRepository.register<Task>(
            testData.taskBox, testData.taskAdapter);

        verify(HiveManagedRepository.hiveInterface
            .registerAdapter(testData.taskAdapter));
        expect(
            HiveManagedRepository.getBoxName<Task>(), equals(testData.taskBox));
      });

      test('should throw because of double type registration', () {
        final testData = TestData();

        expect(HiveManagedRepository.isInitialized, equals(true));

        expect(
            () => HiveManagedRepository.register<Task>(
                testData.taskBox, testData.taskAdapter),
            throwsHiveManagedError('$Task is already registered'));
      });
    });
    group('.closeBox()', () {
      test('should close box', () async {
        final testData = TestData();

        final box = MockBox();

        when(HiveManagedRepository.hiveInterface.isBoxOpen(testData.taskBox))
            .thenReturn(true);
        when(HiveManagedRepository.hiveInterface.box(testData.taskBox))
            .thenReturn(box);

        await HiveManagedRepository.closeBox<Task>();

        verify(HiveManagedRepository.hiveInterface.isBoxOpen(testData.taskBox));
        verify(HiveManagedRepository.hiveInterface.box(testData.taskBox));
        verify(box.close());
      });
    });
  });
}
