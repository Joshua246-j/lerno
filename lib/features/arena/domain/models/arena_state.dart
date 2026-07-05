import 'arena_question.dart';

enum MatchStatus { searching, vsScreen, playing, finished }

class ArenaMatchResult {
  final int xpEarned;
  final int coinsEarned;
  final int trophiesDelta;
  final bool isWin;
  final bool leaguePromoted;
  final String newLeague;
  final String oldLeague;

  const ArenaMatchResult({
    required this.xpEarned,
    required this.coinsEarned,
    required this.trophiesDelta,
    required this.isWin,
    required this.leaguePromoted,
    required this.newLeague,
    required this.oldLeague,
  });
}

class ArenaState {
  final MatchStatus status;
  final int playerScore;
  final int opponentScore;
  final String opponentName;
  final String opponentAvatar;
  final int opponentTrophies;
  final ArenaQuestion? currentQuestion;
  final String? winner; // 'player', 'opponent', or null
  final bool showCorrectAnswer;
  final int? selectedOptionIndex;
  final int secondsRemaining;
  final ArenaMatchResult? matchResult; // Stored when game finishes

  const ArenaState({
    this.status = MatchStatus.searching,
    this.playerScore = 0,
    this.opponentScore = 0,
    this.opponentName = 'Opponent',
    this.opponentAvatar = 'assets/svg/avatars/starter/robot.svg',
    this.opponentTrophies = 0,
    this.currentQuestion,
    this.winner,
    this.showCorrectAnswer = false,
    this.selectedOptionIndex,
    this.secondsRemaining = 10,
    this.matchResult,
  });

  ArenaState copyWith({
    MatchStatus? status,
    int? playerScore,
    int? opponentScore,
    String? opponentName,
    String? opponentAvatar,
    int? opponentTrophies,
    ArenaQuestion? currentQuestion,
    String? winner,
    bool? showCorrectAnswer,
    int? selectedOptionIndex,
    int? secondsRemaining,
    ArenaMatchResult? matchResult,
  }) {
    return ArenaState(
      status: status ?? this.status,
      playerScore: playerScore ?? this.playerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      opponentName: opponentName ?? this.opponentName,
      opponentAvatar: opponentAvatar ?? this.opponentAvatar,
      opponentTrophies: opponentTrophies ?? this.opponentTrophies,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      winner: winner ?? this.winner,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      selectedOptionIndex: selectedOptionIndex, // can be null
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      matchResult: matchResult ?? this.matchResult,
    );
  }
}
