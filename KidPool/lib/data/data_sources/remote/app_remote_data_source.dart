import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
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

  AppRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AppVersionModel> getAppVersion({
    required int roleId,
    required String device,
    required String versionNumber,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.getAppVersion,
        queryParameters: {
          ApiConstants.roleId: roleId,
          ApiConstants.device: device,
          ApiConstants.versionNumber: versionNumber,
        },
      );

      if (response.statusCode == 200) {
        return AppVersionModel.fromJson(response.data);
      } else {
        throw ServerException(response.statusMessage ?? "Server error");
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParsingException("Failed to parse response: ${e.toString()}");
    }
  }
}
