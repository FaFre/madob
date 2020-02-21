// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'madob_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final typeId = 0;

  @override
  Project read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      fields[0] as String,
    ).._title = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._title);
  }
}
