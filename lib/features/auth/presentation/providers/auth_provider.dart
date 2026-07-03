import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/features/auth/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    checkSession();
  }

  Future<void> checkSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final hasSession = await _authRepository.checkSession();
      if (hasSession) {
        state = state.copyWith(status: AuthStatus.authenticated, isLoading: false);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.login(phoneNumber);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _authRepository.verifyOtp(otp);
      if (success) {
        state = state.copyWith(status: AuthStatus.authenticated, isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid OTP');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.logout();
      state = state.copyWith(status: AuthStatus.unauthenticated, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
