import 'package:flutter/material.dart';

class LeagueTier {
  final String leagueId;
  final String leagueName;
  final String svgShield;
  final int minTrophy;
  final int maxTrophy;
  final String rewardId;
  final Color themeColor;

  const LeagueTier({
    required this.leagueId,
    required this.leagueName,
    required this.svgShield,
    required this.minTrophy,
    required this.maxTrophy,
    required this.rewardId,
    required this.themeColor,
  });

  static const List<LeagueTier> allLeagues = [
    LeagueTier(
      leagueId: 'bronze_1',
      leagueName: 'Bronze I',
      svgShield: 'assets/svg/league/bronze_1.svg',
      minTrophy: 0,
      maxTrophy: 99,
      rewardId: 'none',
      themeColor: Color(0xFFCD7F32),
    ),
    LeagueTier(
      leagueId: 'bronze_2',
      leagueName: 'Bronze II',
      svgShield: 'assets/svg/league/bronze_2.svg',
      minTrophy: 100,
      maxTrophy: 199,
      rewardId: 'bronze_chest',
      themeColor: Color(0xFFCD7F32),
    ),
    LeagueTier(
      leagueId: 'bronze_3',
      leagueName: 'Bronze III',
      svgShield: 'assets/svg/league/bronze_3.svg',
      minTrophy: 200,
      maxTrophy: 299,
      rewardId: 'bronze_chest',
      themeColor: Color(0xFFCD7F32),
    ),
    LeagueTier(
      leagueId: 'silver_1',
      leagueName: 'Silver I',
      svgShield: 'assets/svg/league/silver_1.svg',
      minTrophy: 300,
      maxTrophy: 399,
      rewardId: 'silver_chest',
      themeColor: Color(0xFFC0C0C0),
    ),
    LeagueTier(
      leagueId: 'silver_2',
      leagueName: 'Silver II',
      svgShield: 'assets/svg/league/silver_2.svg',
      minTrophy: 400,
      maxTrophy: 499,
      rewardId: 'silver_chest',
      themeColor: Color(0xFFC0C0C0),
    ),
    LeagueTier(
      leagueId: 'silver_3',
      leagueName: 'Silver III',
      svgShield: 'assets/svg/league/silver_3.svg',
      minTrophy: 500,
      maxTrophy: 599,
      rewardId: 'silver_chest',
      themeColor: Color(0xFFC0C0C0),
    ),
    LeagueTier(
      leagueId: 'gold',
      leagueName: 'Gold',
      svgShield: 'assets/svg/league/gold.svg',
      minTrophy: 600,
      maxTrophy: 799,
      rewardId: 'gold_chest',
      themeColor: Color(0xFFFFD700),
    ),
    LeagueTier(
      leagueId: 'crystal',
      leagueName: 'Crystal',
      svgShield: 'assets/svg/league/crystal.svg',
      minTrophy: 800,
      maxTrophy: 999,
      rewardId: 'crystal_chest',
      themeColor: Color(0xFFE0B0FF),
    ),
    LeagueTier(
      leagueId: 'diamond',
      leagueName: 'Diamond',
      svgShield: 'assets/svg/league/diamond.svg',
      minTrophy: 1000,
      maxTrophy: 1499,
      rewardId: 'diamond_chest',
      themeColor: Color(0xFFb9f2ff),
    ),
    LeagueTier(
      leagueId: 'master',
      leagueName: 'Master',
      svgShield: 'assets/svg/league/master.svg',
      minTrophy: 1500,
      maxTrophy: 1999,
      rewardId: 'master_chest',
      themeColor: Color(0xFFff69b4),
    ),
    LeagueTier(
      leagueId: 'champion',
      leagueName: 'Champion',
      svgShield: 'assets/svg/league/champion.svg',
      minTrophy: 2000,
      maxTrophy: 2999,
      rewardId: 'champion_chest',
      themeColor: Color(0xFFff4500),
    ),
    LeagueTier(
      leagueId: 'legend',
      leagueName: 'Legend',
      svgShield: 'assets/svg/league/legend.svg',
      minTrophy: 3000,
      maxTrophy: 999999,
      rewardId: 'legend_chest',
      themeColor: Color(0xFF000000),
    ),
  ];

  static LeagueTier getLeagueForTrophies(int trophies) {
    for (final league in allLeagues) {
      if (trophies >= league.minTrophy && trophies <= league.maxTrophy) {
        return league;
      }
    }
    return allLeagues.last;
  }
}
