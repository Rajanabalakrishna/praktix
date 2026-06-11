class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://dummyjson.com';
  static const String productsEndpoint = '/products';
  static const String usersEndpoint = '/users';
  static const int pageSize = 10;


  static const String ngrokurl = "https://overrashly-vicissitudinous-ayla.ngrok-free.dev";

  static const String apiApplications = '/api/applications';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}