import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expert_entity.dart';
import '../repositories/feed_repository.dart';

class GetExpertsUseCase implements UseCase<List<ExpertEntity>, GetExpertsParams> {
  final FeedRepository repository;

  const GetExpertsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpertEntity>>> call(GetExpertsParams params) {
    return repository.getExperts(
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetExpertsParams {
  final int skip;
  final int limit;

  const GetExpertsParams({required this.skip, required this.limit});
}