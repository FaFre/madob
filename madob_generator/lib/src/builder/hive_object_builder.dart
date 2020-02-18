import 'package:meta/meta.dart';

import '../entities/madob_class.dart';
import '../entities/madob_key.dart';
import '../entities/madob_property.dart';

class HiveObjectBuilder {
  final MadobClass typeClass;
  final MadobKey key;
  final Map<int, MadobProperty> properties;

  HiveObjectBuilder(
      {@required this.typeClass,
      @required this.key,
      @required this.properties});
}
