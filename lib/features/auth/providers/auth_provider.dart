import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState()) {
    _listenAuthState();
  }

  final AuthRepository _repository;

  StreamSubscription? _subscription;

  void _listenAuthState() {
    _subscription = _repository.authStateChanges().listen((user) async {
      if (user == null) {
        state = state.copyWith(
          isInitialized: true,
          clearUser: true,
          clearError: true,
        );
        return;
      }

      final currentUser = await _repository.currentUserData();

      state = state.copyWith(
        isInitialized: true,
        user: currentUser,
        clearError: true,
      );
    });
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final UserModel user = await _repository.login(
        username: username,
        password: password,
      );

      state = state.copyWith(isInitialized: true, isLoading: false, user: user);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());

      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();

    state = state.copyWith(clearUser: true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
