import 'package:build/build.dart';
import 'package:madob/madob.dart';
import 'package:hive/hive.dart';
import 'package:source_gen/source_gen.dart';

import 'src/hive_object_generator.dart';

export 'src/annotations/madob_getter.dart';
export 'src/annotations/madob_setter.dart';
export 'src/annotations/madob_type.dart';

/// Returns a [PartBuilder] to generate [HiveObject]
/// and [Madob]-managed classes
Builder getMadobGenerator(BuilderOptions options) =>
    PartBuilder([MadobObjectGenerator()], '.madob_generator.g.dart');
