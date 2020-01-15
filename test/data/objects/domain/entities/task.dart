import 'package:hive_managed/src/entities/key.dart';

import 'project.dart';

abstract class ITask implements IKey {
  @override
  String get managedKey;
  Future<String> get title;
  Future<IProject> get project;

  Future<void> setTitle(String newTitle);
  Future<void> setProject(IProject newProject);
}
