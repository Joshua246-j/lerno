import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/core/mock/sticker_config.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/features/store/application/shop_provider.dart';

class StickerShopTab extends ConsumerWidget {
  final UserModel user;

  const StickerShopTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packs = StickerConfig.availablePacks;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: packs.length,
      itemBuilder: (context, index) {
        final pack = packs[index];
        final isOwned = user.inventory.contains(pack.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pack.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        Text('${pack.stickerIds.length} Stickers • ${pack.category}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    if (isOwned)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Owned', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      )
                    else
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          ref.read(audioManagerProvider).playClick();
                          _showPurchaseDialog(context, ref, pack);
                        },
                        icon: const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                        label: Text('${pack.coinCost}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                  ],
                ),
              ),
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pack.stickerIds.map((sid) => SvgPicture.asset(
                    AppAssets.getAvatarPath(sid), // Reusing avatars as mock stickers for now
                    height: 50,
                  )).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, pack) {
    final cost = pack.coinCost;
    if (user.stats.coins < cost) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough coins!')));
       return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Buy ${pack.displayName}?'),
        content: Text('Do you want to unlock this sticker pack for $cost coins?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref.read(shopProvider.notifier).purchaseStickerPack(pack.id, cost);
              if (success && context.mounted) {
                ref.read(audioManagerProvider).playSuccess();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchased ${pack.displayName}!')));
              } else if (context.mounted) {
                 final err = ref.read(shopProvider).error;
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $err')));
              }
            },
            child: const Text('Purchase'),
          )
        ],
      ),
    );
  }
}
