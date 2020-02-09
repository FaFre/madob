import 'src/hive_box_repository.dart';

export 'package:madob/src/madob_error.dart';
export 'package:madob/src/entities/key.dart';
export 'package:madob/src/entities/madob.dart';

export 'package:madob/src/helper/strong_uuid.dart';

/// Singleton for accessing [HiveBoxRepository]
// ignore: non_constant_identifier_names
final HiveBoxRepository BoxRepository = HiveBoxRepository();
