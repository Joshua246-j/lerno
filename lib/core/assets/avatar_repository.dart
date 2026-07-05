import 'package:flutter_riverpod/flutter_riverpod.dart';

final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  return AvatarRepository();
});

class AvatarRepository {
  // Simulating a structured backend response for avatars
  final List<Map<String, dynamic>> _starterAvatars = [
    {
      'id': 'starter_robo_1',
      'displayName': 'Robo Blue',
      'category': 'Robots',
      'rarity': 'Common',
      'unlockType': 'Free',
      'assetPath': 'assets/svg/avatars/robo_blue.svg',
    },
    {
      'id': 'starter_monster_1',
      'displayName': 'Green Squish',
      'category': 'Monsters',
      'rarity': 'Common',
      'unlockType': 'Free',
      'assetPath': 'assets/svg/avatars/monster_green.svg',
    },
    // Add more starter avatars here as we source them
  ];

  final List<Map<String, dynamic>> _storeAvatars = [
    {
      'id': 'store_dino_1',
      'displayName': 'Rex',
      'category': 'Dinosaurs',
      'rarity': 'Rare',
      'unlockType': 'Coins',
      'cost': 500,
      'assetPath': 'assets/svg/avatars/dino_rex.svg',
    },
    // Add more store avatars here
  ];

  List<Map<String, dynamic>> getStarterAvatars() {
    return _starterAvatars;
  }

  List<Map<String, dynamic>> getStoreAvatars() {
    return _storeAvatars;
  }

  String resolvePath(String avatarId) {
    final all = [..._starterAvatars, ..._storeAvatars];
    final match = all.firstWhere((a) => a['id'] == avatarId, orElse: () => _starterAvatars.first);
    return match['assetPath'] as String;
  }
}
