import '../models/sticker_pack.dart';

class StickerConfig {
  static final List<StickerPack> availablePacks = [
    StickerPack(
      id: 'pack_animals',
      displayName: 'Cute Animals',
      category: 'Animals',
      coinCost: 500,
      stickerIds: ['robot', 'dinosaur', 'panda'], // Re-using avatars as mock SVGs
    ),
    StickerPack(
      id: 'pack_greetings',
      displayName: 'Greetings & Emotes',
      category: 'Greetings',
      coinCost: 300,
      stickerIds: ['fox', 'astronaut'], 
    ),
    StickerPack(
      id: 'pack_victory',
      displayName: 'Victory Poses',
      category: 'Victory',
      coinCost: 1000,
      stickerIds: ['wizard', 'penguin', 'dragon'], 
    ),
  ];

  static StickerPack getById(String id) {
    return availablePacks.firstWhere(
      (p) => p.id == id,
      orElse: () => availablePacks.first,
    );
  }
}
