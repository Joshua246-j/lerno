// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvatarModelAdapter extends TypeAdapter<AvatarModel> {
  @override
  final int typeId = 3;

  @override
  AvatarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AvatarModel(
      assetPath: fields[0] as String,
      category: fields[1] as String,
      isFree: fields[2] as bool,
      costCoins: fields[3] as int,
      requiredAchievement: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AvatarModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.assetPath)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.isFree)
      ..writeByte(3)
      ..write(obj.costCoins)
      ..writeByte(4)
      ..write(obj.requiredAchievement);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
