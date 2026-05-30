// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dreamtoon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DreamToonModelAdapter extends TypeAdapter<DreamToonModel> {
  @override
  final int typeId = 1;

  @override
  DreamToonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DreamToonModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      artistId: fields[3] as String,
      artistName: fields[4] as String,
      coverImagePath: fields[5] as String?,
      genres: (fields[6] as List?)?.cast<String>(),
      chapterIds: (fields[7] as List?)?.cast<String>(),
      likes: fields[8] as int,
      createdAt: fields[9] as DateTime?,
      isFeatured: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DreamToonModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.artistId)
      ..writeByte(4)
      ..write(obj.artistName)
      ..writeByte(5)
      ..write(obj.coverImagePath)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.chapterIds)
      ..writeByte(8)
      ..write(obj.likes)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.isFeatured);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamToonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
