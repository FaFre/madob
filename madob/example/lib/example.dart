import 'package:madob/madob.dart';

import 'data/objects/project.dart';
import 'data/objects/task.dart';
import 'helper/path_provider.dart';

void main() async {
  // Directory to store the box(-files) in
  final directory = await PathProvider().getTempDirectory();

  // Register our adapter and define the box name
  // where eveything is going to be saved in
  BoxRepository.init(directory.path);
  BoxRepository.register('projectBox', ProjectAdapter());
  BoxRepository.register('taskBox', TaskAdapter());

  // Generate two unique Id's
  final taskid = StrongUuid().generate();
  final projectId = StrongUuid().generate();

  print('Id for Task: $taskid');
  print('Id for Project: $projectId');

  // Create a new Task and initialize it with the generated Id
  final task = ManagedTask();
  await task.initialize(() => Task(taskid));

  // Create a Project and directly assign it to our Task
  await task.setProject(Project(projectId));

  // Create a duplicate instance of Project at thsi point,
  // to proof sync via projectId later
  final project = ManagedProject();
  await project.initialize(() => Project(projectId));

  // Just perform a simple get/set operation
  await task.setTitle('Test Task');
  print('After .setTitle(): ${await task.title}');

  // Close both boxes to free ressources or simulate an app close
  await BoxRepository.closeBox<Task>();
  await BoxRepository.closeBox<Project>();

  // Set title through closed task
  await (await task.project).setTitle('Test Project');
  // Just mix things up and replace the underlying Project instance
  await task.setProject(project);

  // Close the handle
  await BoxRepository.closeBox<Project>();

  // create a new instance of Project with our defined Id
  final regainedProject = ManagedProject();
  await regainedProject.initialize(() => Project(projectId));

  // Let's see if everything keeps synchronized:
  print('title of project set through task: ${await regainedProject.title}');
  print('title of project through untouched instance: ${await project.title}');
  print('title of project through task: ${await (await task.project).title}');
}
