import 'package:flutter_riverpod/flutter_riverpod.dart';

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepository();
});

class LeagueRepository {
  final List<Map<String, dynamic>> _leagues = [
    {
      'id': 'league_bronze',
      'name': 'Bronze League',
      'themeColor': '0xFFCD7F32',
      'minTrophies': 0,
      'assetPath': 'assets/svg/leagues/bronze.svg',
    },
    {
      'id': 'league_silver',
      'name': 'Silver League',
      'themeColor': '0xFFC0C0C0',
      'minTrophies': 500,
      'assetPath': 'assets/svg/leagues/silver.svg',
    },
    {
      'id': 'league_gold',
      'name': 'Gold League',
      'themeColor': '0xFFFFD700',
      'minTrophies': 1000,
      'assetPath': 'assets/svg/leagues/gold.svg',
    },
  ];

  List<Map<String, dynamic>> getAllLeagues() {
    return _leagues;
  }

  String resolvePath(String leagueId) {
    final match = _leagues.firstWhere((l) => l['id'] == leagueId, orElse: () => _leagues.first);
    return match['assetPath'] as String;
  }
}
