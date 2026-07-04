import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/features/auth/presentation/providers/auth_provider.dart';
import 'package:lerno/features/store/presentation/widgets/avatar_shop_tab.dart';
import 'package:lerno/features/store/presentation/widgets/sticker_shop_tab.dart';
import 'package:lerno/features/store/presentation/widgets/inventory_tab.dart';
import 'package:lerno/features/store/presentation/widgets/featured_tab.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/core/local_storage/hive_boxes.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We listen to auth state to re-render when purchases happen and coins/inventory change
    ref.watch(authProvider);

    // In our mock, we just get the first user to render the UI
    final box = HiveBoxes.getUsersBox();
    if (box.isEmpty) {
      return const Scaffold(body: Center(child: Text('No active user found.')));
    }
    final UserModel user = box.getAt(0)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Shop',
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
                Text('${user.stats.coins}',
                    style: TextStyle(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Featured'),
            Tab(text: 'Daily Deals'),
            Tab(text: 'Avatars'),
            Tab(text: 'Stickers'),
            Tab(text: 'Inventory'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const FeaturedTab(isDailyDeals: false),
          const FeaturedTab(isDailyDeals: true),
          AvatarShopTab(user: user),
          StickerShopTab(user: user),
          InventoryTab(user: user),
        ],
      ),
    );
  }
}
