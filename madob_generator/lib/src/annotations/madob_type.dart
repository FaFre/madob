import 'package:madob/madob.dart';
import 'package:meta/meta.dart';

/// Annotate classes with [MadobType] to generate a [Madob] managed class
class MadobType {
  /// The typeId of the annotated class.
  final int typeId;

  /// Adds an [MadobType] with corresponding [typeId]
  const MadobType({@required this.typeId});
}
