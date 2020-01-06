import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/repositories/hive_repository.dart';
import 'package:meta/meta.dart';

class HiveManager<T extends HiveObject> {
  @visibleForTesting
  static HiveInterface hiveInterface = Hive;

  @visibleForTesting
  static HiveRepositoryImplementation hiveRepository = HiveRepository;

  Future<Box<T>> getBox() async {
    return Hive.openBox(hiveRepository.getBoxName<T>());
  }

  factory HiveManager() => null; //TODO: Singleton
}
