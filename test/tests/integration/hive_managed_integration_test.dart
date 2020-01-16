import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/helper/strong_uuid.dart';
import 'package:test/test.dart';

import '../../data/objects/data/entities/managed_project_model.dart';
import '../../data/objects/data/entities/managed_task_model.dart';
import '../../data/objects/data/entities/project_model.dart';
import '../../data/objects/data/entities/task_model.dart';
import '../common.dart';

void main() {
  String path;
  ManagedTask task;

  setUpAll(() async {
    path = (await getTempDir()).path;
  });

  group('Integration', () {
    group('HiveRepository', () {
      test('.init()', () => HiveRepository.init(path));
      test('.register()', () {
        HiveRepository.register('projectBox', ProjectAdapter());
        HiveRepository.register('taskBox', TaskAdapter());
      });
    });

    group('HiveManaged', () {
      final taskId = StrongUuid().generate();
      final taskTitle = 'Test Task Title';

      final projectId = StrongUuid().generate();
      final projectTitle = 'Test Project Title';

      group('Task', () {
        test('.create()', () async {
          task = ManagedTask();
          await task.initialize(() => Task(taskId));

          await expectLater(task.getId(), equals(taskId));
          expect(task.hiveObject.isInBox, isTrue);
        });

        test('.setTitle()', () async {
          expect(await task.title, isNull);

          await task.setTitle(taskTitle);

          expect(await task.title, taskTitle);
        });

        test('get title', () async {
          final regainedTask = ManagedTask();
          await regainedTask.initialize(() => Task(taskId));

          expect(await regainedTask.title, taskTitle);
        });

        test('.setProject()', () async {
          expect(await task.project, isNull);

          await task.setProject(Project(projectId));

          expect((await task.project).managedKey, equals(projectId));
        });
      });

      group('Project', () {
        test('.setTitle()', () async {
          final regainedProject = ManagedProject();
          await regainedProject.initialize(() => Project(projectId));

          await (await task.project).setTitle(projectTitle);

          expect(await regainedProject.title, equals(projectTitle));
        });
      });
    });
  });
}
