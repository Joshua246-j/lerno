import 'package:hive/hive.dart';

part 'avatar_model.g.dart';

@HiveType(typeId: 3)
class AvatarModel extends HiveObject {
  @HiveField(0)
  String assetPath;

  @HiveField(1)
  String category;

  @HiveField(2)
  bool isFree;

  @HiveField(3)
  int costCoins;

  @HiveField(4)
  String? requiredAchievement;

  AvatarModel({
    required this.assetPath,
    required this.category,
    this.isFree = true,
    this.costCoins = 0,
    this.requiredAchievement,
  });
}
