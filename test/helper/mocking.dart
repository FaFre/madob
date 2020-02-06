import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/hive_manager.dart';
import 'package:hive_managed/src/hive_repository.dart';
import 'package:hive_managed_example/data/objects/data/entities/task_model.dart';
import 'package:hive_managed_example/data/objects/domain/entities/task.dart';
import 'package:mockito/mockito.dart';

class MockHive extends Mock implements HiveInterface {}

class MockHiveRepository extends Mock implements HiveRepository {}

class MockBox<T> extends Mock implements Box<T> {}

class MockHiveObject extends Mock implements HiveObject {}

class MockManagedTask extends Mock implements HiveManaged<MockTask>, ITask {}

class MockTask extends Mock implements Task {}

class MockHiveManagerTask extends Mock implements HiveManager<Task> {}
