import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/features/store/data/repositories/store_repository.dart';

final storeItemsProvider = FutureProvider<List<StoreItem>>((ref) async {
  return ref.read(storeRepositoryProvider).fetchStoreItems();
});

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Store',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 5),
                Text('150',
                    style: TextStyle(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          )
        ],
      ),
      body: ref.watch(storeItemsProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.signal_wifi_off,
                      color: Colors.grey, size: 50),
                  const SizedBox(height: 10),
                  Text(err.toString(),
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            data: (items) {
              final powerUps =
                  items.where((i) => i.category == 'power_up').toList();
              final outfits =
                  items.where((i) => i.category == 'outfit').toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Power-ups',
                        style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const SizedBox(height: 10),
                    ...powerUps.map((item) => _buildStoreItem(
                          context,
                          ref,
                          item.title,
                          item.description,
                          item.price,
                          _getIconForType(item.iconType),
                          Colors.lightBlue,
                        )),
                    const SizedBox(height: 30),
                    const Text('Avatar Outfits',
                        style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const SizedBox(height: 10),
                    ...outfits.map((item) => _buildStoreItem(
                          context,
                          ref,
                          item.title,
                          item.description,
                          item.price,
                          _getIconForType(item.iconType),
                          Colors.purple,
                        )),
                  ],
                ),
              );
            },
          ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'ac_unit':
        return Icons.ac_unit;
      case 'bolt':
        return Icons.bolt;
      case 'remove_red_eye':
        return Icons.remove_red_eye;
      case 'smart_toy':
        return Icons.smart_toy;
      default:
        return Icons.star;
    }
  }

  Widget _buildStoreItem(BuildContext context, WidgetRef ref, String title,
      String desc, int price, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // We aren't fully managing the state of 'coins' yet globally,
              // so we just show a mockup purchase success message.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Purchased $title for $price coins!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryBlue,
              side: const BorderSide(color: AppTheme.primaryBlue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            child: Text('$price Coins'),
          ),
        ],
      ),
    );
  }
}
