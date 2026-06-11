import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praktix/features/auth/data/datasources/firebase_auth_datasource.dart';
//import 'package:praktix/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:praktix/features/auth/domain/repositories/auth_repository.dart';
import 'package:praktix/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:praktix/features/auth/domain/usecases/sign_up_usecase.dart';
import '../../data/repository/auth_repostiory_impl.dart';

import 'auth_notifiers.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:praktix/core/services/local_storage_service.dart';

// Add these two providers — keep everything else unchanged

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // overridden in main.dart via ProviderScope
});

final localStorageServiceProvider = Provider<LocalStorageService>(
      (ref) => LocalStorageService(ref.read(sharedPreferencesProvider)),
);

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>(
      (_) => FirebaseAuthDataSource(),
);

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepositoryImpl(
    ref.read(firebaseAuthDataSourceProvider),
    ref.read(localStorageServiceProvider), // ← add this
  ),
);
final signUpUseCaseProvider = Provider<SignUpUseCase>(
      (ref) => SignUpUseCase(ref.read(authRepositoryProvider)),
);

final signInUseCaseProvider = Provider<SignInUseCase>(
      (ref) => SignInUseCase(ref.read(authRepositoryProvider)),
);

final authNotifierProvider =
AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);