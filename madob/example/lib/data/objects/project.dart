import 'package:hive/hive.dart';
import 'package:madob/madob.dart';
import 'package:madob_generator/madob_generator.dart';

part 'project.g.dart';
part 'project.madob_generator.g.dart';

@MadobType(typeId: 0)
abstract class IProject implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<String> get title;
  @MadobSetter(1)
  Future<void> setTitle(String newTitle);
}
