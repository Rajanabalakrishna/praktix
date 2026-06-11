import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/expert_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<ExpertModel>> getExperts({
    required int skip,
    required int limit,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio;

  const FeedRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ExpertModel>> getExperts({
    required int skip,
    required int limit,
  }) async {
    try {
      // Parallel fetch: products (courses) + users (experts)
      final results = await Future.wait([
        dio.get(
          AppConstants.productsEndpoint,
          queryParameters: {'limit': limit, 'skip': skip},
        ),
        dio.get(
          AppConstants.usersEndpoint,
          queryParameters: {'limit': limit, 'skip': skip},
        ),
      ]);

      final products =
      (results[0].data['products'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final users =
      (results[1].data['users'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      return List.generate(products.length, (i) {
        final user = i < users.length
            ? users[i]
            : <String, dynamic>{'firstName': 'Expert', 'lastName': '${i + 1}'};
        return ExpertModel.fromDummyJson(
          product: products[i],
          user: user,
          index: skip + i,
        );
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure();
      }
      throw ServerFailure(e.message ?? 'Server error');
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }
}