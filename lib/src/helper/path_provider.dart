import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as path;

class PathProvider {
  static final PathProvider _singleton = PathProvider._internal();
  factory PathProvider() => _singleton;

  final _random = Random();
  String _tempPath;

  PathProvider._internal() {
    _tempPath = path.join(Directory.current.path, '.dart_tool', 'test', 'tmp');
  }

  Future<Directory> getTempDirectory() async {
    var name = _random.nextInt(pow(2, 32) as int);
    var dir = Directory(path.join(_tempPath, '${name}_tmp'));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);
    return dir;
  }
}
