import 'package:hive_managed/hive_managed.dart';

import '../../domain/entities/project.dart';
import 'project_model.dart';

class ManagedProject extends HiveManaged<Project> implements IProject {
  @override
  String get managedKey => hiveObject.managedKey;

  @override
  Future<void> setTitle(String newTitle) =>
      setValue((project) => project.setTitle(newTitle));

  @override
  Future<String> get title => getValue((project) => project.title);
}
