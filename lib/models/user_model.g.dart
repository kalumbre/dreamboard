// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      userType: fields[4] as String,
      profileImagePath: fields[5] as String?,
      bannerImagePath: fields[6] as String?,
      bio: fields[7] as String,
      favoriteIds: (fields[8] as List?)?.cast<String>(),
      followingIds: (fields[9] as List?)?.cast<String>(),
      boardIds: (fields[10] as List?)?.cast<String>(),
      createdAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.userType)
      ..writeByte(5)
      ..write(obj.profileImagePath)
      ..writeByte(6)
      ..write(obj.bannerImagePath)
      ..writeByte(7)
      ..write(obj.bio)
      ..writeByte(8)
      ..write(obj.favoriteIds)
      ..writeByte(9)
      ..write(obj.followingIds)
      ..writeByte(10)
      ..write(obj.boardIds)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
