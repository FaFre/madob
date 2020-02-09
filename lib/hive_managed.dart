import 'src/hive_repository.dart';

export 'package:madob/src/hive_managed_error.dart';
export 'package:madob/src/entities/key.dart';
export 'package:madob/src/entities/hive_managed.dart';

export 'package:madob/src/helper/strong_uuid.dart';

/// Singleton for accessing [HiveBoxRepository]
// ignore: non_constant_identifier_names
final HiveBoxRepository BoxRepository = HiveBoxRepository();
