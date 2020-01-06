import 'package:hive/hive.dart';
import 'package:hive_managed/src/repositories/hive_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../data/objects/data/entities/project_model.dart';
import '../data/objects/data/entities/task_model.dart';
import 'common.dart';

void main() {
  test('should initialize repository with path', () async {
    final path = await getTempDir();

    HiveRepository.init(path.path);

    expect(HiveRepository.isInitialized, equals(true));
  });

  test('should register project repository', () {
    final box = 'projectBox';
    final adapter = ProjectAdapter();

    expect(HiveRepository.isInitialized, equals(true));

    HiveRepository.register<Project>(box, adapter);

    expect(HiveRepository.getBoxName<Project>(), equals(box));
  });

  test('should register task repository', () {
    final box = 'taskBox';
    final adapter = TaskAdapter();

    expect(HiveRepository.isInitialized, equals(true));

    HiveRepository.register<Task>(box, adapter);

    expect(HiveRepository.getBoxName<Task>(), equals(box));
  });
}
