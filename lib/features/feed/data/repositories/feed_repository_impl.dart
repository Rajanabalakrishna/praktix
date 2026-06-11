import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/expert_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  const FeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExpertEntity>>> getExperts({
    required int skip,
    required int limit,
  }) async {
    try {
      final experts = await remoteDataSource.getExperts(
        skip: skip,
        limit: limit,
      );
      return Right(experts);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}