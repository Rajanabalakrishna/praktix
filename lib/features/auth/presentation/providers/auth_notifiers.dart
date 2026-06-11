

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praktix/features/auth/domain/entities/user_entity.dart';
import 'package:praktix/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:praktix/features/auth/domain/usecases/sign_up_usecase.dart';
import 'auth_providers.dart';

// ── State ────────────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserEntity user;
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final localStorage = ref.read(localStorageServiceProvider);
    final saved = localStorage.getUser();

    if (saved != null) {
      final entity = UserEntity(
        uid: saved['uid']!,
        name: saved['name']!,
        email: saved['email']!,
        role: UserRole.values.firstWhere(
              (r) => r.name == saved['role'],
          orElse: () => UserRole.learner,
        ),
      );
      return AuthAuthenticated(entity);  // ← auto-logged in
    }

    return const AuthInitial();          // ← show login
  }
  Future<void> signUp(SignUpParams params) async {
    state = const AsyncLoading();
    final result = await ref.read(signUpUseCaseProvider)(params);
    state = AsyncData(
      result.fold(
            (failure) => AuthError(failure.message),
            (user) => AuthAuthenticated(user),
      ),
    );
  }

  Future<void> signIn(SignInParams params) async {
    state = const AsyncLoading();
    final result = await ref.read(signInUseCaseProvider)(params);
    state = AsyncData(
      result.fold(
            (failure) => AuthError(failure.message),
            (user) => AuthAuthenticated(user),
      ),
    );
  }

  void resetState() => state = const AsyncData(AuthInitial());
}