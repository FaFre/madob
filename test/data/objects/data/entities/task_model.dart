import 'package:hive/hive.dart';

import '../domain/entities/project.dart';
import '../domain/entities/task.dart';
import 'project_model.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject implements ITask {
  @HiveField(0)
  String _id;

  @override
  String get managedId => _id;

  @HiveField(1)
  String _title;
  @HiveField(2)
  Project _project;

  @override
  Future<IProject> get project => Future.value(_project);

  @override
  Future<void> setProject(IProject newProject) async {
    _project = newProject;
  }

  @override
  Future<String> get title => Future.value(_title);

  @override
  Future<void> setTitle(String newTitle) async {
    _title = newTitle;
  }

  Task(this._id) : assert(_id != null && _id.isNotEmpty);
}