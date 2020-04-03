// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// MadobObjectGenerator
// **************************************************************************

@HiveType(typeId: 2)
class Settings extends HiveObject implements ISettings {
  Settings(this._id) : assert(_id != null && _id.isNotEmpty);

  @HiveField(0)
  final String _id;

  @HiveField(1)
  bool _runAppBugFree;

  @override
  String get managedKey => _id;
  @override
  Future<bool> get runAppBugFree => Future.value(_runAppBugFree);
  @override
  Future<void> setRunAppBugFree(bool value) async => _runAppBugFree = value;
}

class ManagedSettings extends Madob<Settings> implements ISettings {
  @override
  String get managedKey => hiveObject.managedKey;
  @override
  Future<bool> get runAppBugFree =>
      getValue((settings) => settings.runAppBugFree);
  @override
  Future<void> setRunAppBugFree(bool value) async =>
      setValue((settings) => settings.setRunAppBugFree(value));
}
