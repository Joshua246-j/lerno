class UserProfile {
  final String id;
  final String displayName;
  final String phoneNumber;
  final int grade;
  final int coins;
  final int trophies;
  final int currentStreak;
  final DateTime? lastLoginDate;
  final String league; // Bronze, Silver, Gold, Sapphire, Ruby, Diamond
  final String avatarUrl;
  final List<String> badges;

  // New Gamification Fields
  final int level;
  final int totalXP;
  final int streakFreezes;
  final String? equippedBadge;

  final String studentId;
  final int completedLessons;
  final List<String> matchHistory;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.phoneNumber,
    this.grade = 2,
    this.coins = 0,
    this.trophies = 0,
    this.currentStreak = 0,
    this.lastLoginDate,
    this.league = 'Bronze',
    this.avatarUrl = '',
    this.badges = const [],
    this.level = 1,
    this.totalXP = 0,
    this.streakFreezes = 0,
    this.equippedBadge,
    this.studentId = 'STU-000000',
    this.completedLessons = 0,
    this.matchHistory = const [],
  });

  // copyWith method for state management
  UserProfile copyWith({
    String? id,
    String? displayName,
    String? phoneNumber,
    int? grade,
    int? coins,
    int? trophies,
    int? currentStreak,
    DateTime? lastLoginDate,
    String? league,
    String? avatarUrl,
    List<String>? badges,
    int? level,
    int? totalXP,
    int? streakFreezes,
    String? equippedBadge,
    String? studentId,
    int? completedLessons,
    List<String>? matchHistory,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      grade: grade ?? this.grade,
      coins: coins ?? this.coins,
      trophies: trophies ?? this.trophies,
      currentStreak: currentStreak ?? this.currentStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      league: league ?? this.league,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      badges: badges ?? this.badges,
      level: level ?? this.level,
      totalXP: totalXP ?? this.totalXP,
      streakFreezes: streakFreezes ?? this.streakFreezes,
      equippedBadge: equippedBadge ?? this.equippedBadge,
      studentId: studentId ?? this.studentId,
      completedLessons: completedLessons ?? this.completedLessons,
      matchHistory: matchHistory ?? this.matchHistory,
    );
  }
}
