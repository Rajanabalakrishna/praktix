import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expert_entity.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<ExpertEntity>>> getExperts({
    required int skip,
    required int limit,
  });
}