import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';

class BannerInfo {
  final String title;
  final String subtitle;
  final String actionText;
  final String route;
  final Color bgColor;
  final IconData icon;

  const BannerInfo({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.route,
    required this.bgColor,
    required this.icon,
  });
}

const List<BannerInfo> mockBanners = [
  BannerInfo(
    title: 'Double XP Weekend!',
    subtitle: 'Earn 2x XP in all games and courses this weekend.',
    actionText: 'Play Now',
    route: '/main', // Navigates to Games via MainNavigation (mock)
    bgColor: Color(0xFF8B5CF6),
    icon: Icons.bolt,
  ),
  BannerInfo(
    title: 'Ranked Quiz Battle',
    subtitle: 'Climb the leaderboard and earn trophies!',
    actionText: 'Compete',
    route: '/game/quiz_battle',
    bgColor: Color(0xFFF59E0B),
    icon: Icons.emoji_events,
  ),
  BannerInfo(
    title: 'New Avatar Collection',
    subtitle: 'Check out the new Astronaut avatars in the store.',
    actionText: 'Visit Store',
    route: '/store',
    bgColor: Color(0xFF10B981),
    icon: Icons.storefront,
  ),
];

class HeroCarouselWidget extends ConsumerStatefulWidget {
  const HeroCarouselWidget({super.key});

  @override
  ConsumerState<HeroCarouselWidget> createState() => _HeroCarouselWidgetState();
}

class _HeroCarouselWidgetState extends ConsumerState<HeroCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % mockBanners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: GestureDetector(
            onPanDown: (_) => _timer?.cancel(),
            onPanCancel: _startTimer,
            onPanEnd: (_) => _startTimer(),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: mockBanners.length,
              itemBuilder: (context, index) {
                final banner = mockBanners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: banner.bgColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: banner.bgColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(banner.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white)),
                              const SizedBox(height: 8),
                              Text(banner.subtitle,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      height: 1.4)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(audioManagerProvider).playClick();
                                  context.push(banner.route);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: banner.bgColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                ),
                                child: Text(banner.actionText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(banner.icon,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 60),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(mockBanners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppTheme.primaryBlue
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
