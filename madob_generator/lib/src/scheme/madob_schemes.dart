/// List of [Type]-names allowed to be set as a `madobKey`
const List<String> allowedMadobKeyTypes = ['String', 'int'];

/// Prefix for generated Madob-Object's
const String madobClassPrefix = 'Managed';

/// Pattern to validate correct naming of abstract classes
RegExp interfacePattern = RegExp(r'^I[A-Z][A-Za-z0-9]*$');

/// Validate correct naming of abstract classes
bool hasInterfaceNamingConvention(String str) => interfacePattern.hasMatch(str);
