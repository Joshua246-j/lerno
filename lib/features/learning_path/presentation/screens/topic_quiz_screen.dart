import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/learning_path/data/repositories/learning_repository.dart';
import 'package:lerno/features/learning_path/domain/models/learning_models.dart';

class TopicQuizScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String courseId;
  final String topicId;

  const TopicQuizScreen({super.key, required this.subjectId, required this.courseId, required this.topicId});

  @override
  ConsumerState<TopicQuizScreen> createState() => _TopicQuizScreenState();
}

class _TopicQuizScreenState extends ConsumerState<TopicQuizScreen> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _hasSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Topic Quiz', style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Force them to finish or explicitly close
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              ref.read(audioManagerProvider).playClick();
              context.pop(); // Returns to course details
            },
          )
        ],
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: ref.read(learningRepositoryProvider).getQuizForTopic(widget.topicId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
          }

          final questions = snapshot.data ?? [];
          if (questions.isEmpty) {
            return _buildCompletion(context); // Auto complete if no quiz
          }

          if (_currentIndex >= questions.length) {
            return _buildCompletion(context);
          }

          final q = questions[_currentIndex];
          return _buildQuestion(q, questions.length);
        },
      ),
    );
  }

  Widget _buildQuestion(QuizQuestion q, int total) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Question ${_currentIndex + 1} of $total', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(q.questionText, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
          const SizedBox(height: 30),
          ...List.generate(q.options.length, (index) {
            final isSelected = _selectedOption == index;
            final isCorrect = index == q.correctOptionIndex;
            
            Color bgColor = Colors.white;
            Color borderColor = Colors.grey.shade300;
            
            if (_hasSubmitted) {
              if (isCorrect) {
                bgColor = Colors.green.withValues(alpha: 0.1);
                borderColor = Colors.green;
              } else if (isSelected && !isCorrect) {
                bgColor = Colors.red.withValues(alpha: 0.1);
                borderColor = Colors.red;
              }
            } else if (isSelected) {
              bgColor = AppTheme.primaryBlue.withValues(alpha: 0.1);
              borderColor = AppTheme.primaryBlue;
            }

            return GestureDetector(
              onTap: () {
                if (!_hasSubmitted) {
                  ref.read(audioManagerProvider).playClick();
                  setState(() => _selectedOption = index);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Text(
                  q.options[index],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _hasSubmitted && isCorrect ? Colors.green : AppTheme.textDark),
                ),
              ),
            );
          }),
          
          if (_hasSubmitted) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOption == q.correctOptionIndex ? Colors.green.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedOption == q.correctOptionIndex ? "Correct! ${q.explanation}" : "Not quite. ${q.explanation}",
                style: TextStyle(color: _selectedOption == q.correctOptionIndex ? Colors.green.shade700 : Colors.amber.shade700, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          
          const Spacer(),
          ElevatedButton(
            onPressed: _selectedOption == null ? null : () {
              if (!_hasSubmitted) {
                setState(() {
                  _hasSubmitted = true;
                  if (_selectedOption == q.correctOptionIndex) {
                    ref.read(audioManagerProvider).playSuccess();
                  } else {
                    ref.read(audioManagerProvider).playFail();
                  }
                });
              } else {
                setState(() {
                  _currentIndex++;
                  _selectedOption = null;
                  _hasSubmitted = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text(_hasSubmitted ? 'Continue' : 'Check Answer', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 100),
            const SizedBox(height: 24),
            const Text('Topic Complete!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
            const SizedBox(height: 16),
            const Text('You have mastered this topic. Course progress updated!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('+50 XP', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(audioManagerProvider).playSuccess();
                  context.pop(); // Pop back to course details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Continue Learning', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
