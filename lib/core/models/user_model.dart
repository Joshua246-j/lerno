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
  String avatarAsset;

  @HiveField(4)
  GamificationStats stats;

  UserModel({
    required this.phoneNumber,
    required this.displayName,
    required this.age,
    required this.avatarAsset,
    required this.stats,
  });
}
