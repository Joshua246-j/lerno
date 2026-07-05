import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chess_lib;
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';

class ChessPuzzlesScreen extends ConsumerWidget {
  const ChessPuzzlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GameManagerScreen(
      gameTitle: 'Chess Match',
      gameDescription:
          'Play a full game of chess against the computer. Checkmate your opponent to win!',
      gameContent: ChessGameContent(),
    );
  }
}

class ChessGameContent extends ConsumerStatefulWidget {
  const ChessGameContent({super.key});

  @override
  ConsumerState<ChessGameContent> createState() => _ChessGameContentState();
}

class _ChessGameContentState extends ConsumerState<ChessGameContent> {
  late ChessBoardController _controller;
  bool _isGameOver = false;
  bool _isBotThinking = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = ChessBoardController();
    _controller.addListener(_onChessStateChanged);
  }

  void _onChessStateChanged() {
    if (_isGameOver) return;

    if (_controller.isCheckMate() ||
        _controller.isDraw() ||
        _controller.isStaleMate()) {
      setState(() {
        _isGameOver = true;
        _isBotThinking = false;
      });
      // Delay so user can see checkmate
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          final isWin = _controller.isCheckMate() && _controller.game.turn == chess_lib.Color.BLACK;
          GameManagerScope.of(context)?.onEndGame(isWin ? 100 : 20, isWin);
        }
      });
      return;
    }

    if (_controller.game.turn == chess_lib.Color.BLACK && !_isBotThinking) {
      _makeBotMove();
    }
  }

  Future<void> _makeBotMove() async {
    setState(() {
      _isBotThinking = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted || _isGameOver) return;

    final moves = _controller.game.generate_moves();
    if (moves.isEmpty) return;

    List<chess_lib.Move> goodMoves = [];
    List<chess_lib.Move> normalMoves = [];
    
    for (var move in moves) {
      if (move.captured != null || move.promotion != null) {
        goodMoves.add(move);
      } else {
        normalMoves.add(move);
      }
    }

    chess_lib.Move selectedMove;
    if (goodMoves.isNotEmpty) {
      selectedMove = goodMoves[_random.nextInt(goodMoves.length)];
    } else {
      selectedMove = normalMoves[_random.nextInt(normalMoves.length)];
    }

    _controller.makeMove(from: selectedMove.fromAlgebraic, to: selectedMove.toAlgebraic);
    ref.read(audioManagerProvider).playClick();

    if (mounted) {
      setState(() {
        _isBotThinking = false;
      });
    }
  }

  void _undoMove() {
    if (_isBotThinking) return;
    if (_controller.game.history.isNotEmpty) {
      ref.read(audioManagerProvider).playClick();
      _controller.undoMove();
      if (_controller.game.turn == chess_lib.Color.BLACK) {
        _controller.undoMove(); // Undo bot's move as well if it's our turn now
      }
      setState(() {
        _isGameOver = false;
        _isBotThinking = false;
      });
    }
  }

  void _restartGame() {
    ref.read(audioManagerProvider).playClick();
    _controller.resetBoard();
    setState(() {
      _isGameOver = false;
      _isBotThinking = false;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onChessStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Opponent (AI)',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark)),
                  if (_isBotThinking) ...[
                    const SizedBox(width: 10),
                    const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppTheme.primaryBlue)),
                  ]
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('Black',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: AppTheme.modernShadow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                    child: ChessBoard(
                      controller: _controller,
                      boardColor: BoardColor.brown,
                      boardOrientation: PlayerColor.white,
                      enableUserMoves: !_isBotThinking && !_isGameOver,
                      onMove: () {
                        if (_controller.game.turn == chess_lib.Color.BLACK) {
                          ref.read(audioManagerProvider).playClick();
                        }
                      },
                    ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('You',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('White',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _undoMove,
                icon: const Icon(Icons.undo),
                label: const Text('Undo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: AppTheme.textDark,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _restartGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
