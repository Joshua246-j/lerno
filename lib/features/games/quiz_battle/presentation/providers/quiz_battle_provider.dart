import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/models/battle_state.dart';

class QuizBattleNotifier extends StateNotifier<BattleState> {
  QuizBattleNotifier() : super(const BattleState());

  Timer? _botTimer;
  Timer? _nextQuestionTimer;
  final Random _random = Random();
  int _questionIndex = 0;
  List<QuizQuestion> _shuffledBank = [];

  final int scoreToWin = 5;

  void startMatchmaking() {
    state = const BattleState(status: MatchStatus.searching);

    // Simulate finding a match after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _startGame();
    });
  }

  void _startGame() {
    _shuffledBank = List.from(dummyQuestionBank)..shuffle();
    _questionIndex = 0;

    // Pick a random opponent avatar
    final avatars = ['alien.svg', 'robot.svg', 'astronaut.svg'];
    final names = ['Luna', 'Orion', 'Comet'];
    final rIndex = _random.nextInt(3);

    state = state.copyWith(
      status: MatchStatus.playing,
      opponentName: names[rIndex],
      opponentAvatar: 'assets/svg/avatars/starter/${avatars[rIndex]}',
      playerScore: 0,
      opponentScore: 0,
      currentQuestion: _shuffledBank[_questionIndex],
      winner: null,
      showCorrectAnswer: false,
      selectedOptionIndex: null,
      secondsRemaining: 10,
    );

    _startBotCycle();
    _startQuestionTimer();
  }

  void _startBotCycle() {
    _botTimer?.cancel();

    // If the game is already over or transitioning, don't let bot answer
    if (state.status != MatchStatus.playing || state.showCorrectAnswer) return;

    // Bot takes between 2 to 5 seconds to answer
    final delay = _random.nextInt(3000) + 2000;

    _botTimer = Timer(Duration(milliseconds: delay), () {
      if (state.status != MatchStatus.playing || state.showCorrectAnswer) {
        return;
      }

      // Bot has an 80% chance of getting it right
      final isCorrect = _random.nextDouble() > 0.2;

      if (isCorrect) {
        _handleOpponentCorrect();
      } else {
        // If wrong, try again in a bit
        _startBotCycle();
      }
    });
  }

  void submitAnswer(int index) {
    if (state.status != MatchStatus.playing || state.showCorrectAnswer) return;

    final q = state.currentQuestion;
    if (q == null) return;

    state = state.copyWith(selectedOptionIndex: index);

    if (index == q.correctIndex) {
      _handlePlayerCorrect();
    } else {
      // Player got it wrong. In this race style, they can't try again immediately,
      // or we can just let them try again. Let's let them try again for simplicity,
      // but the UI will briefly highlight it red.
    }
  }

  void _handlePlayerCorrect() {
    final newScore = state.playerScore + 1;

    if (newScore >= scoreToWin) {
      _endGame('player');
    } else {
      state = state.copyWith(
        playerScore: newScore,
        showCorrectAnswer: true,
      );
      _moveToNextQuestion();
    }
  }

  void _handleOpponentCorrect() {
    final newScore = state.opponentScore + 1;

    if (newScore >= scoreToWin) {
      _endGame('opponent');
    } else {
      state = state.copyWith(
        opponentScore: newScore,
      );
      // Wait, if opponent gets it right, do we move to the next question for BOTH?
      // Yes, it's a shared question board in a race.
      state = state.copyWith(showCorrectAnswer: true);
      _moveToNextQuestion();
    }
  }

  void _moveToNextQuestion() {
    _botTimer?.cancel();

    _nextQuestionTimer = Timer(const Duration(seconds: 2), () {
      if (state.status != MatchStatus.playing) return;

      _questionIndex++;
      if (_questionIndex >= _shuffledBank.length) {
        _questionIndex = 0; // Wrap around just in case
      }

      state = state.copyWith(
        currentQuestion: _shuffledBank[_questionIndex],
        showCorrectAnswer: false,
        selectedOptionIndex: null, // clear selection for next override
        secondsRemaining: 10,
      );

      _startBotCycle();
      _startQuestionTimer();
    });
  }

  void _startQuestionTimer() {
    _nextQuestionTimer?.cancel();
    _nextQuestionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status != MatchStatus.playing || state.showCorrectAnswer) {
        timer.cancel();
        return;
      }

      if (state.secondsRemaining > 0) {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        timer.cancel();
        // Time's up, just show correct answer and move on
        state = state.copyWith(showCorrectAnswer: true);
        _moveToNextQuestion();
      }
    });
  }

  void _endGame(String winner) {
    _botTimer?.cancel();
    _nextQuestionTimer?.cancel();

    // Update score first to show 5, then finish
    if (winner == 'player') {
      state = state.copyWith(playerScore: scoreToWin);
    } else {
      state = state.copyWith(opponentScore: scoreToWin);
    }

    // Small delay before result screen
    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(
        status: MatchStatus.finished,
        winner: winner,
      );
    });
  }

  void reset() {
    _botTimer?.cancel();
    _nextQuestionTimer?.cancel();
    state = const BattleState();
  }

  @override
  void dispose() {
    _botTimer?.cancel();
    _nextQuestionTimer?.cancel();
    super.dispose();
  }
}

final quizBattleProvider =
    StateNotifierProvider<QuizBattleNotifier, BattleState>((ref) {
  return QuizBattleNotifier();
});
