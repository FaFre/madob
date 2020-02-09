import 'package:madob/madob.dart';
import 'package:test/test.dart';

Matcher throwsMadobError([String contains]) {
  return throwsA(
    allOf(
      isA<MadobError>(),
      predicate((e) =>
          contains == null ||
          e.toString().toLowerCase().contains(contains.toLowerCase())),
    ),
  );
}
