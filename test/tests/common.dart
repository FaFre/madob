import 'package:hive_managed/hive_managed.dart';
import 'package:test/test.dart';

Matcher throwsHiveManagedError([String contains]) {
  return throwsA(
    allOf(
      isA<HiveManagedError>(),
      predicate((e) =>
          contains == null ||
          e.toString().toLowerCase().contains(contains.toLowerCase())),
    ),
  );
}
