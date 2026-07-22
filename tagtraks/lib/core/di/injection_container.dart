import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/data_sources/remote/app_remote_data_source.dart';
import '../../data/data_sources/remote/asset_remote_data_source.dart';
import '../../data/data_sources/remote/auth_remote_data_source.dart';
import '../../data/data_sources/remote/bulk_upload_remote_data_source.dart';
import '../../data/data_sources/remote/dashboard_remote_data_source.dart';
import '../../data/data_sources/remote/profile_remote_data_source.dart';
import '../../data/repositories/app_repository_impl.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/bulk_upload_repository_impl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/app_repository.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/bulk_upload_repository.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/create_asset_usecase.dart';
import '../../domain/usecases/delete_asset_usecase.dart';
import '../../domain/usecases/download_template_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_add_asset_checklist_usecase.dart';
import '../../domain/usecases/get_app_version_usecase.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_site_assets_count_usecase.dart';
import '../../domain/usecases/get_site_assets_usecase.dart';
import '../../domain/usecases/import_assets_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../presentation/providers/add_asset_provider.dart';
import '../../presentation/providers/app_version_provider.dart';
import '../../presentation/providers/asset_list_provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/bulk_upload_provider.dart';
import '../../presentation/providers/dashboard_provider.dart';
import '../../presentation/providers/profile_provider.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Providers
  sl.registerFactory(() => AuthProvider(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Features - App Version
  // Providers
  sl.registerFactory(() => AppVersionProvider(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAppVersionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AppRemoteDataSource>(
    () => AppRemoteDataSourceImpl(sl()),
  );

  // Features - Dashboard
  // Providers
  sl.registerFactory(() => DashboardProvider(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetSiteAssetsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );

  // Features - Asset (Asset List + Add Asset)
  // Providers
  sl.registerFactory(() => AssetListProvider(sl(), sl(), sl()));
  sl.registerFactory(() => AddAssetProvider(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => GetSiteAssetsCountUseCase(sl()));
  sl.registerLazySingleton(() => GetAddAssetChecklistUseCase(sl()));
  sl.registerLazySingleton(() => CreateAssetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAssetUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AssetRemoteDataSource>(
    () => AssetRemoteDataSourceImpl(sl()),
  );

  // Features - Bulk Upload
  // Providers
  sl.registerFactory(() => BulkUploadProvider(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => ImportAssetsUseCase(sl()));
  sl.registerLazySingleton(() => DownloadTemplateUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BulkUploadRepository>(
    () => BulkUploadRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<BulkUploadRemoteDataSource>(
    () => BulkUploadRemoteDataSourceImpl(sl()),
  );

  // Features - Profile
  // Providers
  sl.registerFactory(() => ProfileProvider(sl(), sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}
