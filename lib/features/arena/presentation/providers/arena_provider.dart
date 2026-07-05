import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import '../../domain/models/arena_question.dart';
import '../../domain/models/arena_state.dart';
import '../../data/repositories/arena_repository.dart';

class ArenaProvider extends StateNotifier<ArenaState> {
  final Ref ref;
  final ArenaRepository repository;
  
  ArenaProvider(this.ref, this.repository) : super(const ArenaState());

  Timer? _botTimer;
  Timer? _nextQuestionTimer;
  final Random _random = Random();
  int _questionIndex = 0;
  List<ArenaQuestion> _shuffledBank = [];

  final int scoreToWin = 5;

  void startMatchmaking() async {
    state = const ArenaState(status: MatchStatus.searching);
    
    final user = ref.read(userProfileProvider);
    final playerTrophies = user?.stats.trophies ?? 0;
    
    final opponent = await repository.findOpponent(playerTrophies);
    _shuffledBank = await repository.fetchMatchQuestions(20);

    if (state.status != MatchStatus.searching) return; // User exited

    state = state.copyWith(
      status: MatchStatus.vsScreen,
      opponentName: opponent['name'] as String,
      opponentAvatar: opponent['avatar'] as String,
      opponentTrophies: opponent['trophies'] as int,
    );

    // Show VS screen for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _startGame();
    });
  }

  void _startGame() {
    _questionIndex = 0;

    state = state.copyWith(
      status: MatchStatus.playing,
      playerScore: 0,
      opponentScore: 0,
      currentQuestion: _shuffledBank[_questionIndex],
      winner: null,
      showCorrectAnswer: false,
      selectedOptionIndex: null,
      secondsRemaining: 10,
      matchResult: null,
    );

    _startBotCycle();
    _startQuestionTimer();
  }

  void _startBotCycle() {
    _botTimer?.cancel();

    if (state.status != MatchStatus.playing || state.showCorrectAnswer) return;

    final delay = _random.nextInt(3000) + 2000; // 2-5 seconds

    _botTimer = Timer(Duration(milliseconds: delay), () {
      if (state.status != MatchStatus.playing || state.showCorrectAnswer) return;

      // 80% chance of getting it right
      final isCorrect = _random.nextDouble() > 0.2;

      if (isCorrect) {
        _handleOpponentCorrect();
      } else {
        _startBotCycle(); // Try again
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
    }
    // If wrong, they can't try again immediately? For this race style, let's keep it simple:
    // They just wait for opponent or timer, or we allow retry. Let's allow retry for simplicity.
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
        showCorrectAnswer: true,
      );
      _moveToNextQuestion();
    }
  }

  void _moveToNextQuestion() {
    _botTimer?.cancel();

    _nextQuestionTimer = Timer(const Duration(seconds: 2), () {
      if (state.status != MatchStatus.playing) return;

      _questionIndex++;
      if (_questionIndex >= _shuffledBank.length) {
        _questionIndex = 0;
      }

      state = state.copyWith(
        currentQuestion: _shuffledBank[_questionIndex],
        showCorrectAnswer: false,
        selectedOptionIndex: null,
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
        state = state.copyWith(showCorrectAnswer: true);
        _moveToNextQuestion();
      }
    });
  }

  Future<void> _endGame(String winner) async {
    _botTimer?.cancel();
    _nextQuestionTimer?.cancel();

    if (winner == 'player') {
      state = state.copyWith(playerScore: scoreToWin);
    } else {
      state = state.copyWith(opponentScore: scoreToWin);
    }

    // Give UI a moment to show final score update
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Resolve with backend
    final user = ref.read(userProfileProvider);
    if (user != null) {
      final result = await repository.resolveMatch(user, winner == 'player', state.playerScore, state.opponentTrophies);
      // Refresh user profile
      ref.invalidate(userProfileProvider);
      
      state = state.copyWith(
        status: MatchStatus.finished,
        winner: winner,
        matchResult: result,
      );
    } else {
      state = state.copyWith(
        status: MatchStatus.finished,
        winner: winner,
      );
    }
  }

  void reset() {
    _botTimer?.cancel();
    _nextQuestionTimer?.cancel();
    state = const ArenaState();
  }

  @override
  void dispose() {
    _botTimer?.cancel();
    _nextQuestionTimer?.cancel();
    super.dispose();
  }
}

final arenaProvider = StateNotifierProvider<ArenaProvider, ArenaState>((ref) {
  final repo = ref.read(arenaRepositoryProvider);
  return ArenaProvider(ref, repo);
});
