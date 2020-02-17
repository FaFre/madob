import 'package:madob/madob.dart';
import 'package:madob/src/entities/madob.dart';
import 'package:hive/hive.dart';
import 'package:madob/src/helper/strong_uuid.dart';

import '../../domain/entities/project.dart';
import '../../domain/entities/task.dart';
import 'project_model.dart';
import 'task_model.dart';

class ManagedTask extends Madob<Task> implements ITask {
  ///[Task] is a [HiveObject] created by **hive_generator**
  ///[ITask] is also implemented by [Task] and defines the **getters** and **setters**

  ///[managedKey] is a unique [dynamic] key defined by [Hive] and is used to identify objects.
  ///Take a look into the [StrongUuid] for generating Uuid's shipped with this package.
  @override
  String get managedKey => hiveObject.managedKey;

  ///[getValue] ensures that this [HiveObject] is stored in the database and therefore does hold the synchronized value before getting [title]
  @override
  Future<String> get title => getValue((task) => task.title);

  ///[setValue] ensures that this [HiveObject] is stored in the database before [setTitle] is called to set the object value and write it to the database afterwards
  @override
  Future<void> setTitle(String newTitle) =>
      setValue((task) => task.setTitle(newTitle));

  ///[getOrUpdateReference] ensures that both, this [HiveObject] and the [project] reference are stored in the database before returning it
  @override
  Future<IProject> get project => getOrUpdateReference<Project>(
      (task) async => await task.project,
      (task, newProject) => task.setProject(newProject));

  ///[setReference] ensures that both, this [HiveObject] and [newProject] are stored in the database before updating it
  @override
  Future<void> setProject(IProject newProject) => setReference<Project>(
      newProject, (task, newProject) => task.setProject(newProject));
}
