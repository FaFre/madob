import 'key.dart';

abstract class IProject implements IKey {
  @override
  String get managedId;
  String title;
}