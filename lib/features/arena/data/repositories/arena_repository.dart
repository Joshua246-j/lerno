import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';
import '../../domain/models/arena_question.dart';
import '../../domain/models/arena_state.dart';

final arenaRepositoryProvider = Provider((ref) {
  return ArenaRepository(ref.read(gamificationRepositoryProvider));
});

class ArenaRepository {
  final GamificationRepository gamificationRepo;
  final Random _random = Random();

  ArenaRepository(this.gamificationRepo);

  /// Mock finding a real opponent based on player's trophies
  Future<Map<String, dynamic>> findOpponent(int playerTrophies) async {
    await Future.delayed(const Duration(seconds: 3));
    final avatars = ['alien.svg', 'robot.svg', 'default_user.svg', 'octopus.svg'];
    final names = ['Luna', 'Orion', 'Comet', 'Nova', 'Astro'];
    final rIndex = _random.nextInt(avatars.length);
    final rNameIndex = _random.nextInt(names.length);

    // Mock an opponent with trophies close to the player (+/- 60 trophies)
    final diff = _random.nextInt(120) - 60;
    int opponentTrophies = playerTrophies + diff;
    if (opponentTrophies < 0) opponentTrophies = 0;

    return {
      'name': names[rNameIndex],
      'avatar': 'assets/svg/avatars/starter/${avatars[rIndex]}',
      'trophies': opponentTrophies,
    };
  }

  /// Mock fetching a random pool of questions for the match
  Future<List<ArenaQuestion>> fetchMatchQuestions(int count) async {
    // In a real app, this would hit a backend to sync questions across both clients
    final pool = [
      const ArenaQuestion(
          id: 'q1',
          questionText: 'What is 8 x 7?',
          options: ['54', '56', '62', '48'],
          correctIndex: 1),
      const ArenaQuestion(
          id: 'q2',
          questionText: 'Which planet is closest to the Sun?',
          options: ['Venus', 'Earth', 'Mercury', 'Mars'],
          correctIndex: 2),
      const ArenaQuestion(
          id: 'q3',
          questionText: 'What is the capital of France?',
          options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
          correctIndex: 2),
      const ArenaQuestion(
          id: 'q4',
          questionText: 'How many continents are there?',
          options: ['5', '6', '7', '8'],
          correctIndex: 2),
      const ArenaQuestion(
          id: 'q5',
          questionText: 'Water freezes at what temperature (Celsius)?',
          options: ['0', '32', '100', '-10'],
          correctIndex: 0),
      const ArenaQuestion(
          id: 'q6',
          questionText: 'Who painted the Mona Lisa?',
          options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Michelangelo'],
          correctIndex: 1),
      const ArenaQuestion(
          id: 'q7',
          questionText: 'What is the largest ocean?',
          options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
          correctIndex: 3),
      const ArenaQuestion(
          id: 'q8',
          questionText: 'Which animal is the fastest land animal?',
          options: ['Cheetah', 'Lion', 'Horse', 'Leopard'],
          correctIndex: 0),
    ];

    pool.shuffle();
    return pool.take(count).toList();
  }

  /// Resolves the match and returns the updated User and the Match Result breakdown
  Future<ArenaMatchResult> resolveMatch(UserModel user, bool isWin, int playerScore, int opponentTrophies) async {
    final oldLeague = user.stats.league;
    final oldTrophies = user.stats.trophies;
    
    // Uses gamification repo to actually apply the stats
    final updatedUser = gamificationRepo.resolveRankedBattle(user, isWin: isWin, score: playerScore, opponentTrophies: opponentTrophies);
    
    final newLeague = updatedUser.stats.league;
    final leaguePromoted = _getLeagueRank(newLeague) > _getLeagueRank(oldLeague);

    final xpEarned = isWin ? 30 : 10;
    final coinsEarned = isWin ? 15 : 5;
    final trophiesDelta = updatedUser.stats.trophies - oldTrophies;

    return ArenaMatchResult(
      xpEarned: xpEarned,
      coinsEarned: coinsEarned,
      trophiesDelta: trophiesDelta,
      isWin: isWin,
      leaguePromoted: leaguePromoted,
      newLeague: newLeague,
      oldLeague: oldLeague,
    );
  }

  int _getLeagueRank(String league) {
    switch (league) {
      case 'Legend': return 13;
      case 'Champion': return 12;
      case 'Master': return 11;
      case 'Gold I': return 10;
      case 'Gold II': return 9;
      case 'Gold III': return 8;
      case 'Silver I': return 7;
      case 'Silver II': return 6;
      case 'Silver III': return 5;
      case 'Bronze I': return 4;
      case 'Bronze II': return 3;
      case 'Bronze III': return 2;
      case 'Unranked': return 1;
      default: return 0;
    }
  }
}
