import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:madob_example/data/objects/data/entities/managed_task_model.dart';
import 'package:madob_example/data/objects/data/entities/task_model.dart';

import '../helper/common.dart';
import '../helper/mocking.dart';

void main() {
  //Just a basic test of proxy functionality
  group('Madob', () {
    group('proxy check', () {
      test('.getId() should throw because uninitialized', () async {
        final managedTask = ManagedTask()
          ..hiveManagerInterface = MockHiveManagerTask();

        expect(managedTask.getId, throwsMadobError('No hive instance'));
      });

      test('.getId() should call interface', () async {
        final managedTask = ManagedTask()
          ..hiveManagerInterface = MockHiveManagerTask()
          ..hiveObject = Task('doesntmatter');

        managedTask.getId();

        verify(managedTask.hiveManagerInterface.getId(managedTask.hiveObject));
        verifyNoMoreInteractions(managedTask.hiveManagerInterface);
      });
    });
  });
}
