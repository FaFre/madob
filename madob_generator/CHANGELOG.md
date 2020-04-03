# MadobGenerator

## 0.2.3

- Bugfix: Only wrap references (derived from `get`) into Madob when they are not-null. Elsewise an unobvious not-null check on `hiveObject` would be necessary.

## 0.2.2

- `MadobSetter` distinct between `referencedHiveObject` and `referencedMadobObject`
- Enhanced code generation: Automatic unwrapping of Madob-objects via `setReference`

## 0.2.1

- Direct wrapping into Madob instead returning raw hive object-references via `get`
- Enhanced code generation: Support for custom-named setter + getter

## 0.2.0

- Added code generation for object-references

## 0.1.0

- Initial release
