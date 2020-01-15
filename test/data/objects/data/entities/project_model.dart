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
  String get title => _title;
  @override
  set title(newTitle) {
    _title = newTitle;
  }

  Project(this._id) : assert(_id != null && _id.isNotEmpty);
}
