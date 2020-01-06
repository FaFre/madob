import 'package:test/test.dart';

import 'tests/hive_repository_test.dart' as repository;
import 'tests/hive_manager_test.dart' as manager;

void main() {
  group('HiveRepository', repository.main);
  group('HiveManager', manager.main);
}
