import 'package:madob/madob.dart';

import 'data/objects/settings.dart';
import 'helper/path_provider.dart';

void main() async {
  final directory = await PathProvider().getFixedDirectory();

  BoxRepository.init(directory.path);
  BoxRepository.register('settingsBox', SettingsAdapter());

  var settings = ManagedSettings();
  await settings.initialize(() => Settings('appSettings'));

  var currentValue = (await settings.runAppBugFree) ?? false;
  print('Run app bug free: $currentValue');

  await settings.setRunAppBugFree(!currentValue);
}
