import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/entities/hive_object_reference.dart';
import 'package:hive_managed/src/entities/hive_managed.dart';

import '../../domain/entities/project.dart';
import '../../domain/entities/task.dart';
import 'project_model.dart';
import 'task_model.dart';

class ManagedTask extends HiveManaged<Task, ManagedTask>
    implements ITask, HiveObjectReference<Task> {
  @override
  Task hiveObject;

  @override
  String get managedId => hiveObject.managedId;

  @override
  Future<IProject> get project async => getOrUpdateReference<Project>(
      (task) => task.project,
      (task, newProject) => task.setProject(newProject));

  @override
  Future<void> setProject(IProject newProject) => setReference<Project>(
      newProject, (task, newProject) => task.setProject(newProject));

  @override
  Future<void> setTitle(String newTitle) =>
      setValue((task) => task.setTitle(newTitle));

  @override
  Future<String> get title => getValue((task) => task.title);
}
