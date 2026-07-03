import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/features/gamification/domain/models/gamification_models.dart';

class DailyTasksScreen extends StatelessWidget {
  final List<TaskProgress> taskProgresses;
  // In a real app, we would have a full list of Task definitions as well
  // to show title, description, and targetValue. For this UI mockup,
  // we will simulate the definitions.

  const DailyTasksScreen({
    super.key,
    required this.taskProgresses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quests'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: taskProgresses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final progress = taskProgresses[index];
          // Mock definition data based on index for UI purposes
          final title = _getMockTitle(index);
          final maxVal = _getMockTarget(index);
          final isDone = progress.currentValue >= maxVal;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDone ? Colors.green.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDone ? Colors.green.shade200 : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green : Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone ? Icons.check : Icons.star,
                    color: isDone ? Colors.white : Colors.blue.shade800,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value:
                              (progress.currentValue / maxVal).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDone ? Colors.green : Colors.blue,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${progress.currentValue} / $maxVal',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDone && !progress.isRewardClaimed)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Claim reward logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Claim'),
                    ).animate().scale(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut,
                        ),
                  )
              ],
            ),
          )
              .animate()
              .fadeIn(delay: Duration(milliseconds: 100 * index))
              .slideY(begin: 0.2);
        },
      ),
    );
  }

  String _getMockTitle(int index) {
    if (index == 0) return 'Complete 3 Math Games';
    if (index == 1) return 'Earn 100 XP';
    return 'Maintain 5-Day Streak';
  }

  int _getMockTarget(int index) {
    if (index == 0) return 3;
    if (index == 1) return 100;
    return 5;
  }
}
