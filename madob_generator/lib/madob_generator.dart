import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/hive_object_generator.dart';

export 'src/annotations/madob_getter.dart';
export 'src/annotations/madob_setter.dart';
export 'src/annotations/madob_type.dart';

Builder getMadobGenerator(BuilderOptions options) =>
    SharedPartBuilder([HiveObjectGenerator()], 'madob_generator');
