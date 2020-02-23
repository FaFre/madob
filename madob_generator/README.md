# MadobGenerator

MadobGenerator provides automated code generation for **managed database objects** used by **Madob**.

## Example

```dart
@MadobType(typeId: 0)
abstract class IProject implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<String> get title;
  @MadobSetter(1)
  Future<void> setTitle(String newTitle);
}
```
