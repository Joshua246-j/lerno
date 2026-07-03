import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/providers/network_provider.dart';

final storeRepositoryProvider = Provider((ref) {
  final isOnline = ref.watch(networkProvider);
  return StoreRepository(isOnline);
});

class StoreItem {
  final String id;
  final String title;
  final String description;
  final int price;
  final String iconType;
  final String category;

  const StoreItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.iconType,
    required this.category,
  });
}

class StoreRepository {
  final bool _isOnline;

  StoreRepository(this._isOnline);

  Future<List<StoreItem>> fetchStoreItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_isOnline) {
      throw Exception(
          'Store is unavailable offline. Please connect to the internet.');
    }

    return const [
      StoreItem(
        id: 'item_freeze_1',
        title: 'Streak Freeze',
        description: 'Keep your streak safe for one missed day.',
        price: 50,
        iconType: 'ac_unit',
        category: 'power_up',
      ),
      StoreItem(
        id: 'item_xp_boost',
        title: 'XP Boost',
        description: 'Double XP for 15 minutes.',
        price: 150,
        iconType: 'bolt',
        category: 'power_up',
      ),
      StoreItem(
        id: 'item_glasses',
        title: 'Cool Glasses',
        description: 'Make Juno look smart!',
        price: 100,
        iconType: 'remove_red_eye',
        category: 'outfit',
      ),
      StoreItem(
        id: 'item_pirate',
        title: 'Pirate Hat',
        description: 'Ahoy matey!',
        price: 200,
        iconType: 'smart_toy',
        category: 'outfit',
      ),
    ];
  }

  Future<bool> purchaseItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!_isOnline) {
      throw Exception('Cannot purchase items offline.');
    }
    // Simulate successful purchase
    return true;
  }
}
