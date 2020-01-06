import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed_error.dart';
import 'package:hive_managed/src/repositories/hive_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../data/objects/data/entities/project_model.dart';
import '../data/objects/data/entities/task_model.dart';
import 'common.dart';

void main() {
  final taskBox = 'taskBox';
  final taskAdapter = TaskAdapter();

  final projectBox = 'projectBox';
  final projectAdpater = ProjectAdapter();

  group('repository initialization', () {
    test('register() should throw because repsoitory uninitialized', () {
      expect(() => HiveRepository.register<Task>(taskBox, taskAdapter),
          throwsHiveManagedError('not initialized'));
    });
    test('getBoxName() should throw because repsoitory uninitialized', () {
      expect(() => HiveRepository.getBoxName<Task>(),
          throwsHiveManagedError('not initialized'));
    });
    test('should initialize repository with path', () async {
      final path = await getTempDir();

      HiveRepository.init(path.path);

      expect(HiveRepository.isInitialized, equals(true));
    });
    test('should throw because of double initialization', () {
      expect(() => HiveRepository.init('doesntmatter'), throwsHiveManagedError('already initialized'));
    });
  });

  group('box + adapter registration', () {
    test('should throw because unregistered', () {
      expect(HiveRepository.isInitialized, equals(true));
      expect(() => HiveRepository.getBoxName<Project>(), throwsHiveManagedError('unknown'));
    });
    test('should register project repository', () {
      expect(HiveRepository.isInitialized, equals(true));

      HiveRepository.register<Project>(projectBox, projectAdpater);

      expect(HiveRepository.getBoxName<Project>(), equals(projectBox));
    });

    test('should throw because of double box registration', () {
      expect(HiveRepository.isInitialized, equals(true));

      expect(() => HiveRepository.register<Task>(projectBox, taskAdapter),
          throwsHiveManagedError('$projectBox is already registered'));
    });

    test('should register task repository', () {
      expect(HiveRepository.isInitialized, equals(true));

      HiveRepository.register<Task>(taskBox, taskAdapter);

      expect(HiveRepository.getBoxName<Task>(), equals(taskBox));
    });

    test('should throw because of double type registration', () {
      expect(HiveRepository.isInitialized, equals(true));

      expect(() => HiveRepository.register<Task>(taskBox, taskAdapter),
          throwsHiveManagedError('$Task is already registered'));
    });
  });
}
