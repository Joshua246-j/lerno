import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/features/gamification/domain/models/league_system.dart';
import 'package:lerno/features/gamification/presentation/widgets/league_shield_widget.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<UserModel> _leaguePlayers = [];
  List<UserModel> _globalPlayers = [];
  List<UserModel> _friendsPlayers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(gamificationRepositoryProvider);
    final profile = ref.read(userProfileProvider);
    final currentLeague = profile?.stats.league ?? 'Bronze';

    final leagueData = await repo.fetchLeagueLeaderboard(currentLeague);
    final globalData = await repo.fetchGlobalLeaderboard();
    final friendsData = await repo.fetchFriendsLeaderboard();

    if (mounted) {
      setState(() {
        _leaguePlayers = leagueData..sort((a, b) => b.stats.trophies.compareTo(a.stats.trophies));
        _globalPlayers = globalData..sort((a, b) => b.stats.trophies.compareTo(a.stats.trophies));
        _friendsPlayers = friendsData..sort((a, b) => b.stats.trophies.compareTo(a.stats.trophies));
        _isLoading = false;
      });
    }
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
        title: const Text('Leaderboard',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 4,
          onTap: (_) => ref.read(audioManagerProvider).playClick(),
          tabs: const [
            Tab(text: 'League'),
            Tab(text: 'Global'),
            Tab(text: 'Friends'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(_leaguePlayers),
                    _buildList(_globalPlayers),
                    _buildList(_friendsPlayers),
                  ],
                ),
                _buildStickyBottomBanner(),
              ],
            ),
    );
  }

  Widget _buildList(List<UserModel> players) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, bottom: 100, left: 16, right: 16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        return _buildPlayerCard(players[index], index + 1);
      },
    );
  }

  Widget _buildPlayerCard(UserModel player, int rank) {
    final profile = ref.read(userProfileProvider);
    final isCurrentUser = profile != null && player.phoneNumber == profile.phoneNumber;
    final league = LeagueTier.getLeagueForTrophies(player.stats.trophies);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppTheme.pastelGreen : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrentUser
            ? Border.all(color: AppTheme.primaryGreen, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: rank <= 3 ? AppTheme.primaryBlue : AppTheme.textLight,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: AppTheme.pastelBlue,
            child: SvgPicture.asset(
              player.avatarId.isNotEmpty
                  ? player.avatarId
                  : 'assets/images/avatars/astronaut.svg',
              width: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textDark),
                ),
                Text(
                  player.stats.league,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${player.stats.trophies}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LeagueShieldWidget(league: league, size: 20, showName: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBanner() {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    // Just show a mock rank for demonstration, or find actual rank
    // Find current rank in the active tab (using a getter or just mock it)
    int mockRank = _tabController.index == 0
        ? _leaguePlayers.indexWhere((p) => p.phoneNumber == profile.phoneNumber) + 1
        : (_tabController.index == 1
            ? _globalPlayers.indexWhere((p) => p.phoneNumber == profile.phoneNumber) + 1
            : _friendsPlayers.indexWhere((p) => p.phoneNumber == profile.phoneNumber) + 1);
            
    if (mockRank <= 0) mockRank = 42; // arbitrary off-screen mock

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -4))
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildPlayerCard(profile, mockRank),
          ),
        ),
      ),
    );
  }
}
