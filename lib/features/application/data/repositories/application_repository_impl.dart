import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/application_remote_datasource.dart';
import '../models/application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDatasource remoteDatasource;
  const ApplicationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, String>> submitApplication(
      ApplicationEntity entity) async {
    try {
      final model = ApplicationModel.fromEntity(entity);
      final message = await remoteDatasource.submitApplication(model);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}