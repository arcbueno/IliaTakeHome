import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ilia_contacts/core/config/environment_variables.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator(EnvironmentVariables environmentVariables) async {
  // Logger
  getIt.registerLazySingleton<Logger>(() => Logger());

  // Dio
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: environmentVariables.apiUrl,
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
    return dio;
  });

  getIt.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(getIt<Dio>(), getIt<Logger>()),
  );
}
