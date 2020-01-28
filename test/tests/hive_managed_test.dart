import 'package:hive_managed/src/hive_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hive_managed_example/data/objects/data/entities/managed_task_model.dart';
import 'package:hive_managed_example/data/objects/data/entities/task_model.dart';
import 'common.dart';

class MockTask extends Mock implements Task {}

class MockGiveManagerTask extends Mock implements HiveManager<Task> {}

void main() {
  //Just a basic test of proxy functionality
  group('HiveManaged', () {
    group('proxy check', () {
      test('.getId() should throw because uninitialized', () async {
        final managedTask = ManagedTask()
          ..hiveManagerInterface = MockGiveManagerTask();

        expect(() => managedTask.getId(),
            throwsHiveManagedError('No hive instance'));
      });

      test('.getId() should call interface', () async {
        final managedTask = ManagedTask()
          ..hiveManagerInterface = MockGiveManagerTask()
          ..hiveObject = Task('doesntmatter');

        managedTask.getId();

        verify(managedTask.hiveManagerInterface.getId(managedTask.hiveObject));
        verifyNoMoreInteractions(managedTask.hiveManagerInterface);
      });
    });
  });
}
