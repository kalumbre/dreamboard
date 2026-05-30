// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'image_post_model.dart';

class ImagePostModelAdapter extends TypeAdapter<ImagePostModel> {
  @override
  final int typeId = 5;

  @override
  ImagePostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImagePostModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      username: fields[2] as String,
      imagePath: fields[3] as String,
      title: fields[4] as String,
      description: fields[5] as String,
      category: fields[6] as String,
      likes: fields[7] as int,
      likedByIds: (fields[8] as List).cast<String>(),
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ImagePostModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.userId)
      ..writeByte(2)..write(obj.username)
      ..writeByte(3)..write(obj.imagePath)
      ..writeByte(4)..write(obj.title)
      ..writeByte(5)..write(obj.description)
      ..writeByte(6)..write(obj.category)
      ..writeByte(7)..write(obj.likes)
      ..writeByte(8)..write(obj.likedByIds)
      ..writeByte(9)..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagePostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}