import 'package:hive/hive.dart';

part 'gamification_stats.g.dart';

@HiveType(typeId: 2)
class GamificationStats extends HiveObject {
  @HiveField(0)
  int xp;

  @HiveField(1)
  int coins;

  @HiveField(2)
  int level;

  @HiveField(3)
  int trophies;

  @HiveField(4)
  String league;

  @HiveField(5)
  String currentBadge;

  @HiveField(6)
  List<String> achievements;

  @HiveField(7)
  List<String> unlockedAvatars;

  @HiveField(8)
  int currentStreak;

  GamificationStats({
    this.xp = 0,
    this.coins = 0,
    this.level = 1,
    this.trophies = 0,
    this.league = 'Bronze',
    this.currentBadge = 'Beginner',
    this.achievements = const [],
    this.unlockedAvatars = const [],
    this.currentStreak = 0,
  });

  GamificationStats copyWith({
    int? xp,
    int? coins,
    int? level,
    int? trophies,
    String? league,
    String? currentBadge,
    List<String>? achievements,
    List<String>? unlockedAvatars,
    int? currentStreak,
  }) {
    return GamificationStats(
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      trophies: trophies ?? this.trophies,
      league: league ?? this.league,
      currentBadge: currentBadge ?? this.currentBadge,
      achievements: achievements ?? this.achievements,
      unlockedAvatars: unlockedAvatars ?? this.unlockedAvatars,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}
