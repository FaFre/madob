import 'package:hive_managed/hive_managed.dart';

import 'package:hive_managed_example/data/objects/data/entities/managed_task_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/task_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/project_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/managed_project_model.dart';
import 'package:hive_managed_example/helper/path_provider.dart';

void main() async {
  final directory = await PathProvider().getTempDirectory();

  HiveManagedRepository.init(directory.path);
  HiveManagedRepository.register('projectBox', ProjectAdapter());
  HiveManagedRepository.register('taskBox', TaskAdapter());

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
  await HiveManagedRepository.closeBox<Task>();
  await HiveManagedRepository.closeBox<Project>();

  //Set title through closed task
  await (await task.project).setTitle('Test Project');

  final regainedProject = ManagedProject();
  await regainedProject.initialize(() => Project(projectId));

  print('title of project set through task: ${await regainedProject.title}');
}
