import 'package:hive/hive.dart';
import 'package:hive_managed/hive_managed.dart';
import 'package:hive_managed/src/managed/hive_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../data/objects/data/entities/task_model.dart';

class MockHive extends Mock implements HiveInterface {}

void main() {
  setUp(() {
    HiveManager.hiveInterface = MockHive();
  });

  test('hive repository is ready', () {
    expect(HiveRepository.isInitialized, true);
  });

  test('get task box', () async {
    var box = await HiveManager<Task>().getBox();
  });
}
