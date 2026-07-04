import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/games/common/presentation/game_manager_screen.dart';

class ChessPuzzlesScreen extends ConsumerWidget {
  const ChessPuzzlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GameManagerScreen(
      gameTitle: 'Chess Match',
      gameDescription: 'Play a full game of chess against the computer. Checkmate your opponent to win!',
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

  @override
  void initState() {
    super.initState();
    _controller = ChessBoardController();
    _controller.addListener(_onChessStateChanged);
  }

  void _onChessStateChanged() {
    if (_isGameOver) return;

    if (_controller.isCheckMate() || _controller.isDraw() || _controller.isStaleMate()) {
      setState(() {
        _isGameOver = true;
      });
      // Delay so user can see checkmate
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          final isWin = _controller.isCheckMate();
          GameManagerScope.of(context)?.onEndGame(isWin ? 100 : 20, isWin);
        }
      });
    }
  }

  void _undoMove() {
    if (_controller.game.history.isNotEmpty) {
      ref.read(audioManagerProvider).playClick();
      _controller.undoMove();
      setState(() {
        _isGameOver = false;
      });
    }
  }

  void _restartGame() {
    ref.read(audioManagerProvider).playClick();
    _controller.resetBoard();
    setState(() {
      _isGameOver = false;
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
              const Text('Opponent (AI)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                child: const Text('Black', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    onMove: () {
                      ref.read(audioManagerProvider).playClick();
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
              const Text('You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                child: const Text('White', style: TextStyle(fontWeight: FontWeight.bold)),
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

