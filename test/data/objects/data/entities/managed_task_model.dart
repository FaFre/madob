import 'package:hive_managed/src/entities/hive_object_reference.dart';
import 'package:hive_managed/src/entities/hive_managed.dart';

import '../../domain/entities/project.dart';
import '../../domain/entities/task.dart';
import 'task_model.dart';

class ManagedTask extends HiveManaged<Task, ManagedTask>
    implements ITask, HiveObjectReference<Task> {
  Task hiveObject;

  @override
  // TODO: implement managedId
  String get managedId => null;

  @override
  // TODO: implement project
  Future<IProject> get project => null;

  @override
  Future<void> setProject(IProject newProject) {
    // TODO: implement setProject
    return null;
  }

  @override
  Future<void> setTitle(String newTitle) {
    // TODO: implement setTitle
    return null;
  }

  @override
  // TODO: implement title
  Future<String> get title => null;
}
