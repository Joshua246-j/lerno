import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/core/mock/avatar_config.dart';
import 'package:lerno/core/mock/sticker_config.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/features/store/application/shop_provider.dart';

class InventoryTab extends ConsumerWidget {
  final UserModel user;

  const InventoryTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Collect owned items
    final ownedAvatars = AvatarConfig.allAvatars
        .where((a) => user.inventory.contains(a.avatarId))
        .toList();
    final ownedStickerPacks = StickerConfig.availablePacks
        .where((p) => user.inventory.contains(p.id))
        .toList();

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Text('My Avatars',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark)),
          ),
        ),
        if (ownedAvatars.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No avatars owned yet.',
                    style: TextStyle(color: Colors.grey))),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final avatar = ownedAvatars[index];
                  final isEquipped = user.avatarId == avatar.avatarId;

                  return GestureDetector(
                    onTap: () {
                      if (!isEquipped) {
                        ref.read(audioManagerProvider).playClick();
                        ref
                            .read(shopProvider.notifier)
                            .equipAvatar(avatar.avatarId);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: isEquipped
                            ? Border.all(color: AppTheme.primaryBlue, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 5,
                              spreadRadius: 1),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              AppAssets.getAvatarPath(avatar.avatarId),
                              height: 40),
                          const SizedBox(height: 8),
                          if (isEquipped)
                            const Text('Equipped',
                                style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10))
                          else
                            const Text('Equip',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
                childCount: ownedAvatars.length,
              ),
            ),
          ),
        const SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Text('My Stickers',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark)),
          ),
        ),
        if (ownedStickerPacks.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No sticker packs owned yet.',
                    style: TextStyle(color: Colors.grey))),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final pack = ownedStickerPacks[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const CircleAvatar(
                      backgroundColor: AppTheme.primaryLight,
                      child: Icon(Icons.sticky_note_2,
                          color: AppTheme.primaryBlue)),
                  title: Text(pack.displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle:
                      Text('${pack.stickerIds.length} stickers ready for chat'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text('View'),
                  ),
                );
              },
              childCount: ownedStickerPacks.length,
            ),
          )
      ],
    );
  }
}
