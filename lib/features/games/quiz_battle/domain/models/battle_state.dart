import 'quiz_question.dart';

enum MatchStatus { searching, playing, finished }

class BattleState {
  final MatchStatus status;
  final int playerScore;
  final int opponentScore;
  final String opponentName;
  final String opponentAvatar;
  final QuizQuestion? currentQuestion;
  final String? winner; // 'player', 'opponent', or null (if tie/ongoing)
  final bool
      showCorrectAnswer; // Briefly show the correct answer after a choice
  final int? selectedOptionIndex; // For UI feedback
  final int secondsRemaining;

  const BattleState({
    this.status = MatchStatus.searching,
    this.playerScore = 0,
    this.opponentScore = 0,
    this.opponentName = 'Opponent',
    this.opponentAvatar = 'assets/images/avatars/robot.svg',
    this.currentQuestion,
    this.winner,
    this.showCorrectAnswer = false,
    this.selectedOptionIndex,
    this.secondsRemaining = 10,
  });

  BattleState copyWith({
    MatchStatus? status,
    int? playerScore,
    int? opponentScore,
    String? opponentName,
    String? opponentAvatar,
    QuizQuestion? currentQuestion,
    String? winner,
    bool? showCorrectAnswer,
    int? selectedOptionIndex,
    int? secondsRemaining,
  }) {
    return BattleState(
      status: status ?? this.status,
      playerScore: playerScore ?? this.playerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      opponentName: opponentName ?? this.opponentName,
      opponentAvatar: opponentAvatar ?? this.opponentAvatar,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      winner: winner ?? this.winner,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      selectedOptionIndex: selectedOptionIndex, // Nullable override
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    );
  }
}
