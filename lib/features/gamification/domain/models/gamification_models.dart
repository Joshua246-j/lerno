class League {
  final String id;
  final String name; // Bronze, Silver, Gold, Sapphire, Ruby, Diamond
  final int minTrophies;
  final String iconUrl;

  const League({
    required this.id,
    required this.name,
    required this.minTrophies,
    required this.iconUrl,
  });
}

class Task {
  final String id;
  final String title;
  final String description;
  final int targetValue; // e.g., 3 (for "Play 3 games")
  final int xpReward;
  final int coinReward;
  final String taskType; // daily, weekly, achievement

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.xpReward,
    required this.coinReward,
    required this.taskType,
  });
}

class TaskProgress {
  final String taskId;
  final int currentValue;
  final bool isCompleted;
  final bool isRewardClaimed;

  const TaskProgress({
    required this.taskId,
    required this.currentValue,
    this.isCompleted = false,
    this.isRewardClaimed = false,
  });

  TaskProgress copyWith({
    String? taskId,
    int? currentValue,
    bool? isCompleted,
    bool? isRewardClaimed,
  }) {
    return TaskProgress(
      taskId: taskId ?? this.taskId,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      isRewardClaimed: isRewardClaimed ?? this.isRewardClaimed,
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // For CDN
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.unlockedAt,
  });
}
