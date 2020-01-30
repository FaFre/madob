import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/helper/strong_uuid.dart';
import 'package:test/test.dart';

import 'package:hive_managed_example/data/objects/data/entities/managed_project_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/managed_task_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/project_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/task_model.dart';
import 'package:hive_managed_example/helper/path_provider.dart';

void main() {
  String path;
  ManagedTask task;

  setUpAll(() async {
    path = (await PathProvider().getTempDirectory()).path;
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

          expect(task.getId(), equals(taskId));
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

          expect(await regainedTask.title, equals(taskTitle));
        });

        test('.setProject()', () async {
          expect(await task.project, isNull);

          await task.setProject(Project(projectId));

          expect((await task.project).managedKey, equals(projectId));
        });
      });

      group('HiveRepository', () {
        test('.closeBox()', () async {
          await HiveRepository.closeBox<Task>();
          expect(task.hiveObject.box.isOpen, isFalse);
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

      group('Regained Task', () {
        test('get project title (changed through project)', () async {
          expect(await (await task.project).title, equals(projectTitle));
        });

        test('check parallel sync on set', () async {
          final taskOne = ManagedTask();
          await taskOne.initialize(() => Task(taskId));

          final taskTwo = ManagedTask();
          await taskTwo.initialize(() => Task(taskId));

          await taskTwo.setTitle('Sync #1');
          expect(await taskOne.title, equals(await taskTwo.title));

          await taskOne.setTitle('Sync #2');
          expect(await taskOne.title, equals(await taskTwo.title));
        });
      });
    });
  });
}
