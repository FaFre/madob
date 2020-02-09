import 'package:madob/src/entities/key.dart';

abstract class IProject implements IKey {
  @override
  String get managedKey;

  Future<String> get title;
  Future<void> setTitle(String newTitle);
}
