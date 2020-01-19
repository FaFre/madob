import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/helper/path_provider.dart';

import '../../test/data/objects/data/entities/project_model.dart';
import '../../test/data/objects/data/entities/task_model.dart';
import '../../test/data/objects/data/entities/managed_task_model.dart';
import '../../test/data/objects/data/entities/managed_project_model.dart';

void main() async {
  final directory = await PathProvider().getTempDirectory();

  HiveRepository.init(directory.path);
  HiveRepository.register('projectBox', ProjectAdapter());
  HiveRepository.register('taskBox', TaskAdapter());

  final taskid = StrongUuid().generate();
  final projectId = StrongUuid().generate();

  final task = ManagedTask();
  await task.initialize(() => Task(taskid));

  await task.setTitle('Test Task');
  print('After .setTitle(): ${await task.title}');

  await task.setProject(Project(projectId));
  print(
      'Id of project after .setProject(): ${(await task.project).managedKey}');

  //Close both boxes
  await HiveRepository.closeBox<Task>();
  await HiveRepository.closeBox<Project>();

  //Set title through closed task
  await (await task.project).setTitle('Test Project');

  final regainedProject = ManagedProject();
  await regainedProject.initialize(() => Project(projectId));

  print('title of project set through task: ${await regainedProject.title}');
}
