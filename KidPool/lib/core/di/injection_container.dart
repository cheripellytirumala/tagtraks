import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../config/env_config.dart';
import '../network/api_client.dart';
import '../network/error_interceptor.dart';
import '../../data/data_sources/remote/app_remote_data_source.dart';
import '../../data/repositories/app_repository_impl.dart';
import '../../domain/repositories/app_repository.dart';
import '../../domain/usecases/get_app_version_usecase.dart';
import '../../presentation/providers/app_version_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - App Version
  // Providers
  sl.registerFactory(() => AppVersionProvider(getAppVersionUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAppVersionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AppRemoteDataSource>(
    () => AppRemoteDataSourceImpl(apiClient: sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));

  // External
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    
    dio.interceptors.add(ErrorInterceptor());
    
    if (EnvConfig.isDevelopment) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
    
    return dio;
  });
}
