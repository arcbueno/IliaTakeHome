import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Logger
  getIt.registerLazySingleton<Logger>(() => Logger());

  // Dio
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: String.fromEnvironment(
          'API_URL',
          defaultValue: 'https://api.example.com',
        ),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    // Add base options here later, e.g. from .env
    // dio.options.baseUrl = dotenv.env['API_URL'] ?? '';
    return dio;
  });

  // Register repositories and use cases here
}
