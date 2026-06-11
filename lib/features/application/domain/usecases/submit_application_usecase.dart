

import 'package:dartz/dartz.dart';
//import '../../../../core/error/failures.dart';
import '../../../../core/errors/failures.dart';
import '../entities/application_entity.dart';
import '../repositories/application_repository.dart';

class SubmitApplicationUsecase {
  final ApplicationRepository repository;
  const SubmitApplicationUsecase(this.repository);

  Future<Either<Failure, String>> call(ApplicationEntity entity) =>
      repository.submitApplication(entity);
}