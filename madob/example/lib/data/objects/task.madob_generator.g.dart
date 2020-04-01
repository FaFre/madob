// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// MadobObjectGenerator
// **************************************************************************

@HiveType(typeId: 1)
class Task extends HiveObject implements ITask {
  Task(this._id) : assert(_id != null && _id.isNotEmpty);

  @HiveField(0)
  final String _id;

  @HiveField(1)
  String _title;

  @HiveField(2)
  IProject _project;

  @override
  String get managedKey => _id;
  @override
  Future<String> get title => Future.value(_title);
  @override
  Future<void> setTitle(String newTitle) async => _title = newTitle;
  @override
  Future<IProject> get project => Future.value(_project);
  @override
  Future<void> setProject(IProject newProject) async => _project = newProject;
}

class ManagedTask extends Madob<Task> implements ITask {
  @override
  String get managedKey => hiveObject.managedKey;
  @override
  Future<String> get title => getValue((task) => task.title);
  @override
  Future<void> setTitle(String newTitle) async =>
      setValue((task) => task.setTitle(newTitle));
  @override
  Future<IProject> get project async => Future.value(ManagedProject()
    ..hiveObject = await getOrUpdateReference<Project>(
        (task) async => await task.project,
        (task, newProject) => task.setProject(newProject)));
  @override
  Future<void> setProject(IProject newProject) async => setReference<Project>(
      (newProject is ManagedProject) ? newProject.hiveObject : newProject,
      (task, newProject) => task.setProject(newProject));
}
