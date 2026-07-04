import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/store_repository.dart';
import 'package:lerno/features/auth/presentation/providers/auth_provider.dart';

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  final repo = ref.watch(shopRepositoryProvider);
  return ShopNotifier(repo, ref);
});

class ShopState {
  final bool isLoading;
  final String? error;

  const ShopState({
    this.isLoading = false,
    this.error,
  });

  ShopState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ShopState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ShopNotifier extends StateNotifier<ShopState> {
  final MockShopRepository _repository;
  final Ref _ref;

  ShopNotifier(this._repository, this._ref) : super(const ShopState());

  Future<bool> purchaseAvatar(String avatarId, int cost) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.purchaseAvatar(avatarId, cost);
      state = state.copyWith(isLoading: false);

      // We must notify the auth provider to refresh the user session state
      // so the UI reflects the deducted coins and updated inventory.
      if (success) {
        _ref.read(authProvider.notifier).checkSession();
      }
      return success;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> purchaseStickerPack(String packId, int cost) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.purchaseStickerPack(packId, cost);
      state = state.copyWith(isLoading: false);
      if (success) {
        _ref.read(authProvider.notifier).checkSession();
      }
      return success;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> equipAvatar(String avatarId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.equipAvatar(avatarId);
      state = state.copyWith(isLoading: false);
      _ref.read(authProvider.notifier).checkSession();
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
    }
  }
}
