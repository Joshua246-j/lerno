import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/home/presentation/screens/home_screen.dart';
import 'package:lerno/features/learning_path/presentation/screens/my_courses_screen.dart';
import 'package:lerno/features/games/presentation/screens/games_hub_screen.dart';
import 'package:lerno/features/store/presentation/screens/store_screen.dart';
import 'package:lerno/features/profile/presentation/screens/profile_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyCoursesScreen(),
    const GamesHubScreen(),
    const StoreScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Start background music when entering main app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioManagerProvider).playBgm();
    });
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      ref.read(audioManagerProvider).playClick();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent, // Let content background show
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': LucideIcons.home, 'label': 'Home'},
      {'icon': LucideIcons.map, 'label': 'Courses'},
      {'icon': LucideIcons.gamepad2, 'label': 'Games'},
      {'icon': LucideIcons.shoppingBag, 'label': 'Store'},
      {'icon': LucideIcons.user, 'label': 'Profile'},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35), // Pill shape like mockup
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(navItems.length, (index) {
            final isSelected = currentIndex == index;
            final icon = navItems[index]['icon'] as IconData;
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade400,
                  size: isSelected ? 28 : 24,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
