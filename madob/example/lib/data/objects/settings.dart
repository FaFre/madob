import 'package:hive/hive.dart';
import 'package:madob/madob.dart';
import 'package:madob_generator/madob_generator.dart';

part 'settings.g.dart';
part 'settings.madob_generator.g.dart';

@MadobType(typeId: 2)
abstract class ISettings implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<bool> get runAppBugFree;

  @MadobSetter(1)
  Future<void> setRunAppBugFree(bool value);
}
