// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      phoneNumber: fields[0] as String,
      displayName: fields[1] as String,
      age: fields[2] as int,
      avatarId: fields[3] as String,
      stats: fields[4] as GamificationStats,
      userId: fields[8] as String,
      inventory: (fields[9] as List).cast<String>(),
      courseProgress: (fields[5] as Map).cast<String, double>(),
      gameProgress: (fields[6] as Map).cast<String, int>(),
      matchHistory: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.phoneNumber)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.avatarId)
      ..writeByte(4)
      ..write(obj.stats)
      ..writeByte(5)
      ..write(obj.courseProgress)
      ..writeByte(6)
      ..write(obj.gameProgress)
      ..writeByte(7)
      ..write(obj.matchHistory)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.inventory);
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
