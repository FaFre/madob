import 'package:madob/madob.dart';
import 'package:madob_generator/madob_generator.dart';
import 'package:hive/hive.dart';

part 'madob_object.madob_generator.g.dart';
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
