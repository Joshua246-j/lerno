import 'package:flutter/material.dart';

enum LeagueTier {
  bronzeIII('Bronze III', 0, Color(0xFFCD7F32)),
  bronzeII('Bronze II', 100, Color(0xFFCD7F32)),
  bronzeI('Bronze I', 200, Color(0xFFCD7F32)),
  silverIII('Silver III', 350, Color(0xFFC0C0C0)),
  silverII('Silver II', 500, Color(0xFFC0C0C0)),
  silverI('Silver I', 650, Color(0xFFC0C0C0)),
  goldIII('Gold III', 850, Color(0xFFFFD700)),
  goldII('Gold II', 1050, Color(0xFFFFD700)),
  goldI('Gold I', 1250, Color(0xFFFFD700)),
  crystalIII('Crystal III', 1500, Color(0xFFE0B0FF)),
  crystalII('Crystal II', 1750, Color(0xFFE0B0FF)),
  crystalI('Crystal I', 2000, Color(0xFFE0B0FF)),
  masterIII('Master III', 2300, Color(0xFFFF4500)),
  masterII('Master II', 2600, Color(0xFFFF4500)),
  masterI('Master I', 2900, Color(0xFFFF4500)),
  champion('Champion', 3300, Color(0xFFDC143C)),
  grandChampion('Grand Champion', 3800, Color(0xFF8B0000)),
  legend('Legend', 4500, Color(0xFF000000));

  final String name;
  final int minTrophies;
  final Color color;

  const LeagueTier(this.name, this.minTrophies, this.color);

  static LeagueTier getLeagueForTrophies(int trophies) {
    LeagueTier current = LeagueTier.bronzeIII;
    for (final tier in LeagueTier.values) {
      if (trophies >= tier.minTrophies) {
        current = tier;
      } else {
        break;
      }
    }
    return current;
  }

  static LeagueTier? getNextLeague(LeagueTier current) {
    final index = LeagueTier.values.indexOf(current);
    if (index < LeagueTier.values.length - 1) {
      return LeagueTier.values[index + 1];
    }
    return null;
  }
}

class LeagueMatchResult {
  final int trophiesEarned;
  final int xpEarned;
  final int coinsEarned;
  final bool isPromotion;
  final bool isDemotion;
  final LeagueTier newLeague;

  LeagueMatchResult({
    required this.trophiesEarned,
    required this.xpEarned,
    required this.coinsEarned,
    required this.isPromotion,
    required this.isDemotion,
    required this.newLeague,
  });
}

class LeagueCalculator {
  static const int baseWinTrophies = 30;
  static const int baseLossTrophies = -15;

  static LeagueMatchResult calculateRankedMatchResult({
    required bool isVictory,
    required int currentTrophies,
    required LeagueTier currentLeague,
  }) {
    int trophiesEarned = isVictory ? baseWinTrophies : baseLossTrophies;

    // Cannot drop below 0 trophies
    if (currentTrophies + trophiesEarned < 0) {
      trophiesEarned = -currentTrophies;
    }

    final newTotal = currentTrophies + trophiesEarned;
    final newLeague = LeagueTier.getLeagueForTrophies(newTotal);

    final isPromotion = newLeague.index > currentLeague.index;
    final isDemotion = newLeague.index < currentLeague.index;

    return LeagueMatchResult(
      trophiesEarned: trophiesEarned,
      xpEarned: isVictory ? 50 : 10,
      coinsEarned: isVictory ? 20 : 5,
      isPromotion: isPromotion,
      isDemotion: isDemotion,
      newLeague: newLeague,
    );
  }
}
