import 'package:hive_managed/src/entities/key.dart';

abstract class IProject implements IKey {
  @override
  String get managedId;
  String title;
}