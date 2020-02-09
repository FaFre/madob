import 'package:meta/meta.dart';
import 'package:madob/madob.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:madob_example/data/objects/data/entities/project_model.dart';
import 'package:madob_example/data/objects/data/entities/task_model.dart';

import '../helper/common.dart';
import '../helper/mocking.dart';

@immutable
class TestData {
  final String taskBox = 'taskBox';
  final TaskAdapter taskAdapter = TaskAdapter();

  final String projectBox = 'projectBox';
  final ProjectAdapter projectAdapter = ProjectAdapter();
}

void main() {
  setUp(() {
    BoxRepository.hiveInterface = MockHive();
  });

  group('BoxRepository', () {
    test('.register() should throw because repository uninitialized', () {
      final testData = TestData();

      expect(
          () => BoxRepository.register<Task>(
              testData.taskBox, testData.taskAdapter),
          throwsMadobError('not initialized'));
    });
    test('.getBoxName() should throw because repository uninitialized', () {
      expect(BoxRepository.getBoxName, throwsMadobError('not initialized'));
    });
    test('.closeBox() should throw because repository uninitialized', () {
      expect(BoxRepository.closeBox, throwsMadobError('not initialized'));
    });

    group('.init()', () {
      test('should initialize repository with path', () async {
        final fakePath = 'doesntmatter';

        BoxRepository.init(fakePath);

        verify(BoxRepository.hiveInterface.init(fakePath));
        expect(BoxRepository.isInitialized, equals(true));
      });
      test('should throw because of double initialization', () {
        expect(() => BoxRepository.init('doesntmatter'),
            throwsMadobError('already initialized'));
      });
    });

    test('.getBoxName() should throw because unregistered', () {
      expect(BoxRepository.isInitialized, equals(true));
      expect(BoxRepository.getBoxName, throwsMadobError('unknown'));
    });
    test('.register() should register project repository', () {
      final testData = TestData();

      expect(BoxRepository.isInitialized, equals(true));

      BoxRepository.register<Project>(
          testData.projectBox, testData.projectAdapter);

      verify(
          BoxRepository.hiveInterface.registerAdapter(testData.projectAdapter));
      expect(BoxRepository.getBoxName<Project>(), equals(testData.projectBox));
    });

    group('.register()', () {
      test('should throw because of double box registration', () {
        final testData = TestData();

        expect(BoxRepository.isInitialized, equals(true));

        expect(
            () => BoxRepository.register<Task>(
                testData.projectBox, testData.taskAdapter),
            throwsMadobError('${testData.projectBox} is already registered'));
      });

      test('should register task repository', () {
        final testData = TestData();

        expect(BoxRepository.isInitialized, equals(true));

        BoxRepository.register<Task>(testData.taskBox, testData.taskAdapter);

        verify(
            BoxRepository.hiveInterface.registerAdapter(testData.taskAdapter));
        expect(BoxRepository.getBoxName<Task>(), equals(testData.taskBox));
      });

      test('should throw because of double type registration', () {
        final testData = TestData();

        expect(BoxRepository.isInitialized, equals(true));

        expect(
            () => BoxRepository.register<Task>(
                testData.taskBox, testData.taskAdapter),
            throwsMadobError('$Task is already registered'));
      });
    });
    group('.closeBox()', () {
      test('should close box', () async {
        final testData = TestData();

        final box = MockBox<Task>();

        when(BoxRepository.hiveInterface.isBoxOpen(testData.taskBox))
            .thenReturn(true);
        when(BoxRepository.hiveInterface.box(testData.taskBox)).thenReturn(box);

        await BoxRepository.closeBox<Task>();

        verify(BoxRepository.hiveInterface.isBoxOpen(testData.taskBox));
        verify(BoxRepository.hiveInterface.box(testData.taskBox));
        verify(box.close());
      });
    });
  });
}
