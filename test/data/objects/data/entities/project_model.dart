import 'package:hive/hive.dart';

import '../../domain/entities/project.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject implements IProject {
  @HiveField(0)
  String _id;

  @override
  String get managedKey => _id;

  @HiveField(1)
  String _title;

  @override
  Future<String> get title => Future.value(_title);
  @override
  Future<void> setTitle(String newTitle) async {
    _title = newTitle;
  }

  Project(this._id) : assert(_id != null && _id.isNotEmpty);
}
