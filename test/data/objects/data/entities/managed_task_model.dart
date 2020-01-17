import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/entities/hive_managed.dart';

import '../../domain/entities/project.dart';
import '../../domain/entities/task.dart';
import 'project_model.dart';
import 'task_model.dart';

class ManagedTask extends HiveManaged<Task> implements ITask {
  //Task is a HiveObject created by hive_generator
  //ITask is also implemented by Task and defines the getters and setters

  @override
  String get managedKey => hiveObject.managedKey;
  //managedKey is a key of dynamic-type defined by hive

  @override
  Future<String> get title => getValue((task) => task.title);
  //getValue ensures that the HiveObject is stored and does have the same value in the database

  @override
  Future<void> setTitle(String newTitle) =>
      setValue((task) => task.setTitle(newTitle));
  //setValue makes sure the HiveObject does exist in the database and the value is written down

  //It also works with references to other HiveObjects in different boxes:
  @override
  Future<IProject> get project => getOrUpdateReference<Project>(
      (task) async => await task.project,
      (task, newProject) => task.setProject(newProject));

  @override
  Future<void> setProject(IProject newProject) => setReference<Project>(
      newProject, (task, newProject) => task.setProject(newProject));
}
