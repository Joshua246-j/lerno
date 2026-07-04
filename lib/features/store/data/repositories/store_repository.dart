import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/local_storage/hive_boxes.dart';
import 'package:lerno/core/models/user_model.dart';

final shopRepositoryProvider = Provider<MockShopRepository>((ref) {
  return MockShopRepository();
});

class MockShopRepository {
  Future<UserModel?> _getCurrentUser() async {
    // Assuming active session is stored in usersBox under the current phone number,
    // or just take the first user since it's a mock.
    // In auth_repository it's managed via SharedPreferences. 
    // For local mock execution, we can just grab the first user.
    final box = HiveBoxes.getUsersBox();
    if (box.isNotEmpty) {
      return box.getAt(0);
    }
    return null;
  }

  Future<void> _saveUser(UserModel user) async {
    final box = HiveBoxes.getUsersBox();
    await box.put(user.phoneNumber, user);
  }

  Future<bool> purchaseAvatar(String avatarId, int cost) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = await _getCurrentUser();
    if (user == null) throw Exception("User not found.");

    if (user.stats.coins < cost) {
      throw Exception("Not enough coins.");
    }
    if (user.inventory.contains(avatarId)) {
      throw Exception("Item already owned.");
    }

    user.stats.coins -= cost;
    user.inventory.add(avatarId);
    await _saveUser(user);
    return true;
  }

  Future<bool> purchaseStickerPack(String packId, int cost) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = await _getCurrentUser();
    if (user == null) throw Exception("User not found.");

    if (user.stats.coins < cost) {
      throw Exception("Not enough coins.");
    }
    if (user.inventory.contains(packId)) {
      throw Exception("Pack already owned.");
    }

    user.stats.coins -= cost;
    user.inventory.add(packId);
    await _saveUser(user);
    return true;
  }

  Future<void> equipAvatar(String avatarId) async {
    final user = await _getCurrentUser();
    if (user == null) throw Exception("User not found.");
    if (!user.inventory.contains(avatarId)) {
      throw Exception("Avatar not owned.");
    }
    user.avatarId = avatarId;
    await _saveUser(user);
  }
}
