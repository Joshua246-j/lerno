// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GamificationStatsAdapter extends TypeAdapter<GamificationStats> {
  @override
  final int typeId = 2;

  @override
  GamificationStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GamificationStats(
      xp: fields[0] as int,
      coins: fields[1] as int,
      level: fields[2] as int,
      trophies: fields[3] as int,
      league: fields[4] as String,
      currentBadge: fields[5] as String,
      achievements: (fields[6] as List).cast<String>(),
      unlockedAvatars: (fields[7] as List).cast<String>(),
      currentStreak: fields[8] as int,
      dailyMissions: (fields[9] as Map).cast<String, bool>(),
      dailyRewardClaimed: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GamificationStats obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.xp)
      ..writeByte(1)
      ..write(obj.coins)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.trophies)
      ..writeByte(4)
      ..write(obj.league)
      ..writeByte(5)
      ..write(obj.currentBadge)
      ..writeByte(6)
      ..write(obj.achievements)
      ..writeByte(7)
      ..write(obj.unlockedAvatars)
      ..writeByte(8)
      ..write(obj.currentStreak)
      ..writeByte(9)
      ..write(obj.dailyMissions)
      ..writeByte(10)
      ..write(obj.dailyRewardClaimed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamificationStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
