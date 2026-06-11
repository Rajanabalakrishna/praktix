

import 'package:dartz/dartz.dart';
import 'package:praktix/core/errors/failures.dart';
import 'package:praktix/features/auth/domain/entities/user_entity.dart';
import 'package:praktix/features/auth/domain/repositories/auth_repository.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;
}

class SignInUseCase {
  const SignInUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call(SignInParams params) =>
      _repository.signIn(email: params.email, password: params.password);
}