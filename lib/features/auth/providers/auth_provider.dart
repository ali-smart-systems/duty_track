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
  int _authRevision = 0;

  void _listenAuthState() {
    _subscription = _repository.authStateChanges().listen((user) async {
      final revision = ++_authRevision;
      if (user == null) {
        if (!mounted) return;
        state = state.copyWith(
          isInitialized: true,
          clearUser: true,
          clearError: true,
        );
        return;
      }

      try {
        final currentUser = await _repository.currentUserData();
        if (!mounted || revision != _authRevision) return;
        state = state.copyWith(
          isInitialized: true,
          user: currentUser != null && currentUser.isActive && !currentUser.isDeleted
              ? currentUser
              : null,
          clearUser: currentUser == null || !currentUser.isActive || currentUser.isDeleted,
          clearError: true,
        );
      } catch (error) {
        if (!mounted || revision != _authRevision) return;
        state = state.copyWith(
          isInitialized: true,
          clearUser: true,
          errorMessage: 'تعذر التحقق من صلاحية الحساب',
        );
      }
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

      if (!mounted) return false;
      state = state.copyWith(isInitialized: true, isLoading: false, user: user);

      return true;
    } catch (e) {
      if (!mounted) return false;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());

      return false;
    }
  }

  Future<void> logout() async {
    ++_authRevision;
    await _repository.logout();
    if (mounted) state = state.copyWith(clearUser: true);
  }

  @override
  void dispose() {
    ++_authRevision;
    _subscription?.cancel();
    super.dispose();
  }
}
