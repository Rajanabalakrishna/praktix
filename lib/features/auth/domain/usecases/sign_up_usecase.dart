import 'package:dartz/dartz.dart';
import 'package:praktix/core/errors/failures.dart';
import 'package:praktix/features/auth/domain/entities/user_entity.dart';
import 'package:praktix/features/auth/domain/repositories/auth_repository.dart';

class SignUpParams {
  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
  final String name;
  final String email;
  final String password;
  final UserRole role;
}

class SignUpUseCase {
  const SignUpUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call(SignUpParams params) =>
      _repository.signUp(
        name: params.name,
        email: params.email,
        password: params.password,
        role: params.role,
      );
}