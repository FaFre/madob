import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

/// Provides cryptographic strong Uuid's
class StrongUuid {
  static final StrongUuid _singleton = StrongUuid._internal();

  /// Uuid factory
  factory StrongUuid() => _singleton;

  final Uuid _uuid;

  StrongUuid._internal() : _uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  /// Generate a cryptographic strong Uuid of version 4
  String generate() => _uuid.v4();
}
