import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/application/data/datasources/application_remote_datasource.dart';
import '../../features/application/data/repositories/application_repository_impl.dart';
import '../../features/application/domain/repositories/application_repository.dart';
import '../../features/application/domain/usecases/submit_application_usecase.dart';
import '../../features/application/presentation/bloc/application_bloc.dart';
import '../../features/feed/data/datasources/feed_remote_datasource.dart';
import '../../features/feed/data/repositories/feed_repository_impl.dart';
import '../../features/feed/domain/repositories/feed_repository.dart';
import '../../features/feed/domain/usecases/get_experts_usecase.dart';
import '../../features/feed/presentation/blocs/expert_feed_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initFeedDependencies() async {

  // ── External ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => DioClient.instance);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ── Feed: Datasource ──────────────────────────────────────────────────────
  sl.registerLazySingleton<FeedRemoteDataSource>(
        () => FeedRemoteDataSourceImpl(dio: sl()),
  );

  // ── Feed: Repository ──────────────────────────────────────────────────────
  sl.registerLazySingleton<FeedRepository>(
        () => FeedRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Feed: Usecase ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetExpertsUseCase(sl()));

  // ── Feed: BLoC ────────────────────────────────────────────────────────────
  sl.registerFactory(
        () => ExpertFeedBloc(getExpertsUseCase: sl()),
  );

  // ── Application: Datasource ───────────────────────────────────────────────
  sl.registerLazySingleton<ApplicationRemoteDatasource>(
        () => ApplicationRemoteDatasourceImpl(client: sl()),
  );

  // ── Application: Repository ───────────────────────────────────────────────
  sl.registerLazySingleton<ApplicationRepository>(
        () => ApplicationRepositoryImpl(remoteDatasource: sl()),
  );

  // ── Application: Usecase ──────────────────────────────────────────────────
  sl.registerLazySingleton(
        () => SubmitApplicationUsecase(sl()),
  );

  // ── Application: BLoC ────────────────────────────────────────────────────
  sl.registerFactory(
        () => ApplicationBloc(submitApplicationUsecase: sl()),
  );
}