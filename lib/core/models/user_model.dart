import 'package:hive/hive.dart';
import 'gamification_stats.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  String phoneNumber;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  int age;

  @HiveField(3)
  String avatarId;

  @HiveField(4)
  GamificationStats stats;

  @HiveField(5)
  Map<String, double> courseProgress;

  @HiveField(6)
  Map<String, int> gameProgress;

  @HiveField(7)
  List<String> matchHistory;

  @HiveField(8)
  String userId;

  @HiveField(9)
  List<String> inventory;

  UserModel({
    required this.phoneNumber,
    required this.displayName,
    required this.age,
    required this.avatarId,
    required this.stats,
    this.userId = '',
    this.inventory = const [],
    this.courseProgress = const {},
    this.gameProgress = const {},
    this.matchHistory = const [],
  });
}
