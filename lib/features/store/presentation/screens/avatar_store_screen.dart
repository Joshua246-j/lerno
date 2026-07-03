import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';

class AvatarStoreScreen extends ConsumerStatefulWidget {
  const AvatarStoreScreen({super.key});

  @override
  ConsumerState<AvatarStoreScreen> createState() => _AvatarStoreScreenState();
}

class _AvatarStoreScreenState extends ConsumerState<AvatarStoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _starterAvatars = [
    'assets/images/avatars/dinosaur.svg',
    'assets/images/avatars/lion.svg',
    'assets/images/avatars/panda.svg',
    'assets/images/avatars/penguin.svg',
  ];

  final List<String> _premiumAvatars = [
    'assets/images/avatars/alien.svg',
    'assets/images/avatars/astronaut.svg',
    'assets/images/avatars/spaceship.svg',
    'assets/images/avatars/wizard.svg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        title: const Text('Avatar Store', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
            Tab(text: 'Starter (Free)'),
            Tab(text: 'Premium'),
            Tab(text: 'Rare'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAvatarGrid(_starterAvatars, isPremium: false),
          _buildAvatarGrid(_premiumAvatars, isPremium: true),
          const Center(
            child: Text(
              'Unlock via Achievements\n(Coming Soon)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid(List<String> avatars, {required bool isPremium}) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            ref.read(audioManagerProvider).playClick();
            // TODO: Implement Equip/Purchase logic via Provider
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(avatars[index], height: 50),
                const SizedBox(height: 10),
                if (isPremium)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('500', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                else
                  const Text('Equip', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
