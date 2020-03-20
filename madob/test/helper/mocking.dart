import 'package:hive/hive.dart';
import 'package:madob/madob.dart';
import 'package:madob/src/hive_manager.dart';
import 'package:madob/src/hive_box_repository.dart';
import 'package:madob_example/data/objects/task.dart';
import 'package:mockito/mockito.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBoxRepository extends Mock implements HiveBoxRepository {}

class MockBox<T> extends Mock implements Box<T> {}

class MockHiveObject extends Mock implements HiveObject {}

class MockManagedTask extends Mock implements Madob<MockTask>, ITask {}

class MockTask extends Mock implements Task {}

class MockHiveManagerTask extends Mock implements HiveManager<Task> {}
