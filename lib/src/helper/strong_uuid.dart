import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class StrongUuid {
  static final StrongUuid _singleton = StrongUuid._internal();
  factory StrongUuid() => _singleton;

  final Uuid _uuid;

  StrongUuid._internal() : _uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  String generate() => _uuid.v4();
}
