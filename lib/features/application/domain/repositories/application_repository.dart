import 'package:dartz/dartz.dart';
//import '../../../../core/error/failures.dart';
import '../../../../core/errors/failures.dart';
import '../entities/application_entity.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, String>> submitApplication(ApplicationEntity entity);
}