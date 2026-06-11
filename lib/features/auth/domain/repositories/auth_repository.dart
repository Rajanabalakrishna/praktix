


import 'package:dartz/dartz.dart';
import 'package:praktix/core/errors/failures.dart';
import 'package:praktix/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  UserEntity? get currentUser;
}