import 'package:madob/madob.dart';
import 'package:madob_generator/madob_generator.dart';

// ignore: uri_has_not_been_generated
part 'madob_object.g.dart';

@MadobType(typeId: 0)
abstract class IProject implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<String> get title;
  @MadobSetter(1)
  Future<void> setTitle(String newTitle);
}

// class ManagedProject extends Madob<Project> implements IProject {
//   @override
//   String get managedKey => hiveObject.managedKey;

//   @override
//   Future<void> setTitle(String newTitle) =>
//       setValue((project) => project.setTitle(newTitle));

//   @override
//   Future<String> get title => getValue((project) => project.title);
// }

// @HiveType(typeId: 0)
// class Project extends HiveObject implements IProject {
//   @HiveField(0)
//   final String _id;

//   @override
//   String get managedKey => _id;

//   @HiveField(1)
//   String _title;

//   @override
//   Future<String> get title => Future.value(_title);
//   @override
//   Future<void> setTitle(String newTitle) async {
//     _title = newTitle;
//   }

//   Project(this._id) : assert(_id != null && _id.isNotEmpty);
// }
