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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primaryBlue,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.map),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.gamepad2),
                label: 'Games',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.shoppingBag),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.user),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
