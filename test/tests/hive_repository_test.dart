import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../data/objects/data/entities/project_model.dart';
import '../data/objects/data/entities/task_model.dart';
import 'common.dart';

class MockHive extends Mock implements HiveInterface {}

void main() {
  final taskBox = 'taskBox';
  final taskAdapter = TaskAdapter();

  final projectBox = 'projectBox';
  final projectAdpater = ProjectAdapter();

  setUp(() {
    HiveRepository.hiveInterface = MockHive();
  });

  group('HiveRepository', () {
    test('.register() should throw because repsoitory uninitialized', () {
      expect(() => HiveRepository.register<Task>(taskBox, taskAdapter),
          throwsHiveManagedError('not initialized'));
    });
    test('.getBoxName() should throw because repsoitory uninitialized', () {
      expect(() => HiveRepository.getBoxName<Task>(),
          throwsHiveManagedError('not initialized'));
    });
    test('.init() should initialize repository with path', () async {
      final fakePath = 'doesntmatter';

      HiveRepository.init(fakePath);

      verify(HiveRepository.hiveInterface.init(fakePath));
      expect(HiveRepository.isInitialized, equals(true));
    });
    test('.init() should throw because of double initialization', () {
      expect(() => HiveRepository.init('doesntmatter'),
          throwsHiveManagedError('already initialized'));
    });
    test('.getBoxName() should throw because unregistered', () {
      expect(HiveRepository.isInitialized, equals(true));
      expect(() => HiveRepository.getBoxName<Project>(),
          throwsHiveManagedError('unknown'));
    });
    test('.register() should register project repository', () {
      expect(HiveRepository.isInitialized, equals(true));

      HiveRepository.register<Project>(projectBox, projectAdpater);

      verify(HiveRepository.hiveInterface.registerAdapter(projectAdpater));
      expect(HiveRepository.getBoxName<Project>(), equals(projectBox));
    });

    test('.register() should throw because of double box registration', () {
      expect(HiveRepository.isInitialized, equals(true));

      expect(() => HiveRepository.register<Task>(projectBox, taskAdapter),
          throwsHiveManagedError('$projectBox is already registered'));
    });

    test('.register() should register task repository', () {
      expect(HiveRepository.isInitialized, equals(true));

      HiveRepository.register<Task>(taskBox, taskAdapter);

      verify(HiveRepository.hiveInterface.registerAdapter(taskAdapter));
      expect(HiveRepository.getBoxName<Task>(), equals(taskBox));
    });

    test('.register() should throw because of double type registration', () {
      expect(HiveRepository.isInitialized, equals(true));

      expect(() => HiveRepository.register<Task>(taskBox, taskAdapter),
          throwsHiveManagedError('$Task is already registered'));
    });
  });
}
