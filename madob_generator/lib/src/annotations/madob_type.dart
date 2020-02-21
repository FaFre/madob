import 'package:meta/meta.dart';

class MadobType {
  /// The typeId of the annotated class.
  final int typeId;

  /// The name of the generated adapter.
  //TODO: Pass it to HiveType at generation
  final String adapterName;

  /// This parameter can be used to keep track of old fieldIds which must not
  /// be reused. The generator will throw an error if a legacy fieldId is
  /// used again.
  // final List<int> legacyFieldIds;

  /// If [adapterName] is not set, it'll be `"YourClass" + "Adapter"`.
  const MadobType({
    @required this.typeId,
    this.adapterName,
    //this.legacyFieldIds,
  });
}
