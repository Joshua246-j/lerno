import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/gamification_stats.dart';
import '../models/avatar_model.dart';

class HiveBoxes {
  static const String usersBox = 'usersBox';
  static const String avatarsBox = 'avatarsBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(GamificationStatsAdapter());
    Hive.registerAdapter(AvatarModelAdapter());

    // Open Boxes
    await Hive.openBox<UserModel>(usersBox);
    await Hive.openBox<AvatarModel>(avatarsBox);
  }

  static Box<UserModel> getUsersBox() => Hive.box<UserModel>(usersBox);
  static Box<AvatarModel> getAvatarsBox() => Hive.box<AvatarModel>(avatarsBox);
}
