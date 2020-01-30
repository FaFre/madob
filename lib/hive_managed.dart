library hive_managed;

import 'src/hive_repository.dart';

export 'package:hive_managed/src/entities/key.dart';
export 'package:hive_managed/src/entities/hive_managed.dart';

export 'package:hive_managed/src/helper/strong_uuid.dart';

/// Singleton for accessing HiveRepository
// ignore: non_constant_identifier_names
final HiveRepository HiveManagedRepository = HiveRepository();
