import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

//es/feed/presentation/blocs/expert_feed/expert_feed_bloc.dart';
import '../../features/feed/data/datasources/feed_remote_datasource.dart';
import '../../features/feed/data/repositories/feed_repository_impl.dart';
import '../../features/feed/domain/repositories/feed_repository.dart';
import '../../features/feed/domain/usecases/get_experts_usecase.dart';
import '../../features/feed/presentation/blocs/expert_feed_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initFeedDependencies() async {
  // ── External ──
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // ── Data Sources ──
  sl.registerLazySingleton<FeedRemoteDataSource>(
        () => FeedRemoteDataSourceImpl(dio: sl()),
  );

  // ── Repositories ──
  sl.registerLazySingleton<FeedRepository>(
        () => FeedRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Use Cases ──
  sl.registerLazySingleton(() => GetExpertsUseCase(sl()));

  // ── BLoC (factory = fresh instance per page) ──
  sl.registerFactory(
        () => ExpertFeedBloc(getExpertsUseCase: sl()),
  );
}