import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/features/auth/presentation/providers/auth_provider.dart';
import 'package:lerno/features/auth/presentation/screens/splash_screen.dart';
import 'package:lerno/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:lerno/features/auth/presentation/screens/login_screen.dart';
import 'package:lerno/features/auth/presentation/screens/verification_screen.dart';
import 'package:lerno/core/presentation/screens/main_navigation_screen.dart';
import 'package:lerno/features/learning_path/presentation/screens/my_courses_screen.dart';
import 'package:lerno/features/games/quiz_battle/presentation/screens/matchmaking_screen.dart';
import 'package:lerno/features/games/quiz_battle/presentation/screens/battle_arena_screen.dart';
import 'package:lerno/features/games/quiz_battle/presentation/screens/battle_result_screen.dart';
import 'package:lerno/features/games/word_hunt/presentation/screens/word_hunt_screen.dart';
import 'package:lerno/features/games/memory_match/presentation/screens/memory_match_screen.dart';
import 'package:lerno/features/games/math_arena/presentation/screens/math_arena_screen.dart';
import 'package:lerno/features/games/chess/presentation/screens/chess_puzzles_screen.dart';
import 'package:lerno/features/gamification/presentation/screens/leaderboard_screen.dart';
import 'package:lerno/features/gamification/presentation/screens/achievements_screen.dart';
import 'package:lerno/features/rewards/presentation/screens/daily_missions_screen.dart';
import 'package:lerno/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:lerno/features/social/presentation/screens/friends_screen.dart';
import 'package:lerno/features/social/presentation/screens/chat_screen.dart';
import 'package:lerno/features/social/presentation/providers/friends_provider.dart';
import 'package:flutter/material.dart'; // Needed for Scaffold fallback

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthScreen = state.matchedLocation == '/login' || 
                           state.matchedLocation == '/verify' || 
                           state.matchedLocation == '/onboarding';
      
      if (authState.status == AuthStatus.initial) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      if (authState.status == AuthStatus.unauthenticated) {
        if (!isAuthScreen) return '/onboarding';
        return null;
      }

      if (authState.status == AuthStatus.authenticated) {
        if (isAuthScreen || state.matchedLocation == '/splash') {
          return '/main';
        }
        return null;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return VerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/game/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          switch (id) {
            case 'quiz_battle':
              return const MatchmakingScreen();
            case 'word_hunt':
              return const WordHuntScreen();
            case 'memory_match':
              return const MemoryMatchScreen();
            case 'math_arena':
              return const MathArenaScreen();
            case 'chess':
              return const ChessPuzzlesScreen();
            default:
              return const Scaffold(body: Center(child: Text('Game not found')));
          }
        },
      ),
      GoRoute(
        path: '/my_courses',
        builder: (context, state) => const MyCoursesScreen(),
      ),
      GoRoute(
        path: '/matchmaking',
        builder: (context, state) => const MatchmakingScreen(),
      ),
      GoRoute(
        path: '/battle_arena',
        builder: (context, state) => const BattleArenaScreen(),
      ),
      GoRoute(
        path: '/battle_result',
        builder: (context, state) => const BattleResultScreen(),
      ),
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/daily_missions',
        builder: (context, state) => const DailyMissionsScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/friends',
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final friend = state.extra as Friend?;
          if (friend == null) {
            return const Scaffold(body: Center(child: Text('Chat not found')));
          }
          return ChatScreen(friend: friend);
        },
      ),
    ],
  );
});
