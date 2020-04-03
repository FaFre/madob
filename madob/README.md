# Madob

Madob is a super simple and easy to use highly-asynchronous library for database-synchronized objects. It is built upon [hive](https://github.com/hivedb/hive), the blazing-fast key-value database.
It handles **all** database-related stuff under the hood and appears as a fast sports car. Just access your variables with `get` and `set()` as you are used to.

## Use cases

Madob is used to keep data persistent and synchronized across instances by a single Id.
Let my explain this with a simple example:

We have some App-Settings we want to keep persistent. For that we just create a new `MadobType` and let the code generator do the job for us:

```dart
@MadobType(typeId: 2)
abstract class ISettings implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<bool> get runAppBugFree;

  @MadobSetter(1)
  Future<void> setRunAppBugFree(bool value);
}
```

After code generation we can load and store settings like this:

```dart
var settings = ManagedSettings();
await settings.initialize(() => Settings('appSettings'));

var currentValue = (await settings.runAppBugFree) ?? false;
print('Run app bug free: $currentValue');

await settings.setRunAppBugFree(!currentValue);
```

After each run/start of our example, `runAppBugFree` is getting negated and therefor the app is always with a chance of 50% bug-free :). The complete code is available [here](https://github.com/FaFre/madob/tree/master/madob/example/lib/settings_example.dart).

Also take a look at a more comprehensive example [here](https://github.com/FaFre/madob/tree/master/madob/example/lib/example.dart).
