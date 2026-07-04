class StickerPack {
  final String id;
  final String displayName;
  final String category;
  final int coinCost;
  final List<String> stickerIds;
  
  bool owned;

  StickerPack({
    required this.id,
    required this.displayName,
    required this.category,
    required this.coinCost,
    required this.stickerIds,
    this.owned = false,
  });

  StickerPack copyWith({
    bool? owned,
  }) {
    return StickerPack(
      id: id,
      displayName: displayName,
      category: category,
      coinCost: coinCost,
      stickerIds: stickerIds,
      owned: owned ?? this.owned,
    );
  }
}
