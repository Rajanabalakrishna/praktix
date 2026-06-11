import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praktix/core/errors/failures.dart';
import 'package:praktix/core/services/local_storage_service.dart';
import 'package:praktix/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:praktix/features/auth/domain/entities/user_entity.dart';
import 'package:praktix/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._localStorage); // ← both stored
  final FirebaseAuthDataSource _dataSource;
  final LocalStorageService _localStorage;                  // ← added field

  UserEntity? _cachedUser;

  @override
  UserEntity? get currentUser => _cachedUser;

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final credential = await _dataSource.createUser(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      await _dataSource.saveUserProfile(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
        role: role.name,
      );
      final entity = UserEntity(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
        role: role,
      );
      _cachedUser = entity;
      await _localStorage.saveUser(        // ← save on signup too
        uid: uid,
        name: entity.name,
        email: email.trim(),
        role: entity.role.name,
      );
      return Right(entity);
    } on FirebaseAuthException catch (e) {
      return Left(_mapAuthException(e));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _dataSource.signInUser(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      final data = await _dataSource.fetchUserProfile(uid);
      final entity = UserEntity(
        uid: uid,
        name: data?['name'] as String? ?? '',
        email: email.trim(),
        role: _roleFromString(data?['role'] as String?),
      );
      _cachedUser = entity;
      await _localStorage.saveUser(
        uid: uid,
        name: entity.name,
        email: email.trim(),
        role: entity.role.name,
      );
      return Right(entity);
    } on FirebaseAuthException catch (e) {
      return Left(_mapAuthException(e));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOutUser();
      _cachedUser = null;
      await _localStorage.clearUser();     // ← clear on signout
      return const Right(unit);
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  Failure _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'wrong-password':
      case 'invalid-credential':
        return const WrongPasswordFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return UnknownFailure(e.message);
    }
  }

  UserRole _roleFromString(String? role) => UserRole.values.firstWhere(
        (r) => r.name == role,
    orElse: () => UserRole.learner,
  );
}