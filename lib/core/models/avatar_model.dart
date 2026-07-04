class AvatarModel {
  final String avatarId;
  final String displayName;
  final String category;
  final String rarity;
  final String unlockType; // e.g. Free, Coins, XP Level, Achievement
  final int requiredLevel;
  final int requiredXP;
  final int coinCost;
  final String achievementRequirement;

  // These two fields are determined dynamically based on the User's state.
  // We can include them here for UI convenience when mapping.
  bool owned;
  bool equipped;

  AvatarModel({
    required this.avatarId,
    required this.displayName,
    required this.category,
    required this.rarity,
    required this.unlockType,
    this.requiredLevel = 1,
    this.requiredXP = 0,
    this.coinCost = 0,
    this.achievementRequirement = '',
    this.owned = false,
    this.equipped = false,
  });

  AvatarModel copyWith({
    bool? owned,
    bool? equipped,
  }) {
    return AvatarModel(
      avatarId: avatarId,
      displayName: displayName,
      category: category,
      rarity: rarity,
      unlockType: unlockType,
      requiredLevel: requiredLevel,
      requiredXP: requiredXP,
      coinCost: coinCost,
      achievementRequirement: achievementRequirement,
      owned: owned ?? this.owned,
      equipped: equipped ?? this.equipped,
    );
  }
}
