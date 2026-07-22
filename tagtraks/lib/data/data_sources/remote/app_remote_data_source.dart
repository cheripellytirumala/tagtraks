import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/app_version_model.dart';

abstract class AppRemoteDataSource {
  Future<AppVersionModel> getAppVersion({
    required int roleId,
    required String device,
    required String versionNumber,
  });
}

class AppRemoteDataSourceImpl implements AppRemoteDataSource {
  final ApiClient apiClient;

  AppRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AppVersionModel> getAppVersion({
    required int roleId,
    required String device,
    required String versionNumber,
  }) async {
    final response = await apiClient.post(
      ApiConstants.getAppVersion,
      queryParameters: {
        ApiConstants.roleId: roleId,
        ApiConstants.device: device,
        ApiConstants.versionNumber: versionNumber,
      },
    );

    return AppVersionModel.fromJson(response.data);
  }
}
