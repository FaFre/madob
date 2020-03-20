import 'package:hive/hive.dart';
import 'package:madob/madob.dart';
import 'package:madob_generator/madob_generator.dart';

import 'project.dart';

part 'task.g.dart';
part 'task.madob_generator.g.dart';

@MadobType(typeId: 1)
abstract class ITask implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<String> get title;
  @MadobGetter(2)
  Future<IProject> get project;

  @MadobSetter(1)
  Future<void> setTitle(String newTitle);
  @MadobSetter(2, referencedHiveObjectName: 'Project')
  Future<void> setProject(IProject newProject);
}
