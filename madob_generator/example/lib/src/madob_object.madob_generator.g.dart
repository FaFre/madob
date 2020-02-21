// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'madob_object.dart';

// **************************************************************************
// HiveObjectGenerator
// **************************************************************************

@HiveType(typeId: 0)
class Project extends HiveObject implements IProject {
  Project(this._id) : assert(_id != null && _id.isNotEmpty);

  @HiveField(0)
  final String _id;

  @HiveField(1)
  String _title;

  @override
  String get managedKey => _id;
  @override
  Future<String> get title => Future.value(_title);
  @override
  Future<void> setTitle(String newTitle) async => _title = newTitle;
}

class ManagedProject extends Madob<Project> implements IProject {
  @override
  String get managedKey => hiveObject.managedKey;
  @override
  Future<String> get title => getValue((project) => project.title);
  @override
  Future<void> setTitle(String newTitle) async =>
      setValue((project) => project.setTitle(newTitle));
}
