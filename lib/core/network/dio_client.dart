import 'package:dio/dio.dart';
import '../constants/app_constants.dart';



class DioClient {
  DioClient._();

  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        // ignore: avoid_print
        logPrint: (obj) => print('[Dio] $obj'),
      ),
    );

    return dio;
  }
}