import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/core/mock/avatar_config.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/features/store/application/shop_provider.dart';

class AvatarShopTab extends ConsumerWidget {
  final UserModel user;

  const AvatarShopTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatars = AvatarConfig.storeAvatars;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isOwned = user.inventory.contains(avatar.avatarId);
        final isEquipped = user.avatarId == avatar.avatarId;

        return GestureDetector(
          onTap: () {
            ref.read(audioManagerProvider).playClick();
            if (isEquipped) return;
            if (isOwned) {
              ref.read(shopProvider.notifier).equipAvatar(avatar.avatarId);
              return;
            }
            if (avatar.unlockType == 'Coins') {
              _showPurchaseDialog(context, ref, avatar);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Cannot purchase. Requires: ${avatar.unlockType}')));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isEquipped
                  ? Border.all(color: AppTheme.primaryBlue, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      AppAssets.getAvatarPath(avatar.avatarId),
                      placeholderBuilder: (context) => const Icon(Icons.person,
                          size: 50, color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
                Text(avatar.displayName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(avatar.rarity,
                    style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    color:
                        isOwned ? Colors.green.shade100 : AppTheme.primaryLight,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isEquipped) ...[
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const Text('Equipped',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      ] else if (isOwned) ...[
                        const Icon(Icons.check, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const Text('Owned',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      ] else if (avatar.unlockType == 'Coins') ...[
                        const Icon(Icons.monetization_on,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${avatar.coinCost}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue)),
                      ] else ...[
                        const Icon(Icons.lock,
                            color: AppTheme.primaryBlue, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(avatar.unlockType,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                    fontSize: 10),
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, avatar) {
    final cost = avatar.coinCost;
    if (user.stats.coins < cost) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Not enough coins!')));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Unlock ${avatar.displayName}?'),
        content: Text('Do you want to unlock this avatar for $cost coins?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(shopProvider.notifier)
                  .purchaseAvatar(avatar.avatarId, cost);
              if (success && context.mounted) {
                ref.read(audioManagerProvider).playSuccess();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Purchased ${avatar.displayName}!')));
              } else if (context.mounted) {
                final err = ref.read(shopProvider).error;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Failed: $err')));
              }
            },
            child: const Text('Purchase'),
          )
        ],
      ),
    );
  }
}
