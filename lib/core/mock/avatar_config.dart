import '../models/avatar_model.dart';

class AvatarConfig {
  static final List<AvatarModel> starterAvatars = [
    AvatarModel(
      avatarId: 'robot',
      displayName: 'R-72 Robot',
      rarity: 'Common',
      category: 'Robots',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'dinosaur',
      displayName: 'Rexy',
      rarity: 'Common',
      category: 'Dinosaurs',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'panda',
      displayName: 'Panda',
      rarity: 'Common',
      category: 'Animals',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'fox',
      displayName: 'Foxy',
      rarity: 'Common',
      category: 'Animals',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'astronaut',
      displayName: 'Astro Kid',
      rarity: 'Common',
      category: 'Space',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'octopus',
      displayName: 'Ollie',
      rarity: 'Common',
      category: 'Ocean',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'wizard',
      displayName: 'Apprentice',
      rarity: 'Common',
      category: 'Fantasy',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'penguin',
      displayName: 'Penguin',
      rarity: 'Common',
      category: 'Animals',
      unlockType: 'Free',
    ),
    AvatarModel(
      avatarId: 'dragon',
      displayName: 'Dragon',
      rarity: 'Common',
      category: 'Fantasy',
      unlockType: 'Free',
    ),
  ];

  static final List<AvatarModel> storeAvatars = [
    AvatarModel(
      avatarId: 'alien',
      displayName: 'Zorb Alien',
      rarity: 'Uncommon',
      category: 'Space',
      coinCost: 200,
      unlockType: 'Coins',
    ),
    AvatarModel(
      avatarId: 'ninja',
      displayName: 'Shadow Ninja',
      rarity: 'Epic',
      category: 'Heroes',
      coinCost: 1200,
      unlockType: 'Coins',
    ),
    AvatarModel(
      avatarId: 'princess',
      displayName: 'Princess',
      rarity: 'Rare',
      category: 'Fantasy',
      requiredLevel: 5,
      unlockType: 'XP Level',
    ),
    AvatarModel(
      avatarId: 'chef',
      displayName: 'Master Chef',
      rarity: 'Epic',
      category: 'Professionals',
      achievementRequirement: 'Complete 10 Daily Missions',
      unlockType: 'Achievement',
    ),
    AvatarModel(
      avatarId: 'comet',
      displayName: 'Comet',
      rarity: 'Rare',
      category: 'Space',
      coinCost: 500,
      unlockType: 'Coins',
    ),
    AvatarModel(
      avatarId: 'explorer',
      displayName: 'Explorer',
      rarity: 'Rare',
      category: 'Professionals',
      requiredLevel: 10,
      unlockType: 'XP Level',
    ),
    AvatarModel(
      avatarId: 'knight',
      displayName: 'Knight',
      rarity: 'Epic',
      category: 'Fantasy',
      achievementRequirement: 'Win 5 Ranked Battles',
      unlockType: 'Achievement',
    ),
    AvatarModel(
      avatarId: 'lion',
      displayName: 'Lion King',
      rarity: 'Legendary',
      category: 'Animals',
      coinCost: 5000,
      unlockType: 'Coins',
    ),
    AvatarModel(
      avatarId: 'pirate',
      displayName: 'Pirate Captain',
      rarity: 'Epic',
      category: 'Heroes',
      requiredLevel: 15,
      unlockType: 'XP Level',
    ),
    AvatarModel(
      avatarId: 'planet',
      displayName: 'Saturn',
      rarity: 'Rare',
      category: 'Space',
      coinCost: 800,
      unlockType: 'Coins',
    ),
    AvatarModel(
      avatarId: 'scientist',
      displayName: 'Mad Scientist',
      rarity: 'Epic',
      category: 'Professionals',
      achievementRequirement: 'Play 50 Science games',
      unlockType: 'Achievement',
    ),
    AvatarModel(
      avatarId: 'spaceship',
      displayName: 'Star Cruiser',
      rarity: 'Legendary',
      category: 'Space',
      unlockType: 'Ranked Season Reward',
    ),
    AvatarModel(
      avatarId: 'tiger',
      displayName: 'Fierce Tiger',
      rarity: 'Epic',
      category: 'Animals',
      coinCost: 2000,
      unlockType: 'Coins',
    ),
    AvatarModel(
      avatarId: 'unicorn',
      displayName: 'Magic Unicorn',
      rarity: 'Legendary',
      category: 'Fantasy',
      achievementRequirement: 'Get a 30-day streak',
      unlockType: 'Achievement',
    ),
  ];

  static List<AvatarModel> get allAvatars => [...starterAvatars, ...storeAvatars];

  static AvatarModel getById(String id) {
    return allAvatars.firstWhere(
      (a) => a.avatarId == id,
      orElse: () => starterAvatars.first,
    );
  }
}
