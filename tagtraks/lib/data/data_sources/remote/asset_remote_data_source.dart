import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/checklist_field_value.dart';
import '../../models/checklist_item_model.dart';

abstract class AssetRemoteDataSource {
  Future<Map<int, int>> getSiteAssetsCount(int siteId);
  Future<List<ChecklistItemModel>> getAddAssetChecklist(int assetTypeId);
  Future<void> createAsset({
    required int assetTypeId,
    required int siteId,
    required List<ChecklistFieldValue> values,
  });
  Future<void> deleteAsset(int siteAssetId);
}

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final ApiClient client;

  AssetRemoteDataSourceImpl(this.client);

  static final _tokenPattern = RegExp(
    r'name="__RequestVerificationToken"[^>]*value="([^"]+)"',
  );

  @override
  Future<Map<int, int>> getSiteAssetsCount(int siteId) async {
    final response = await client.get(
      ApiConstants.siteAssetsCount,
      queryParameters: {ApiConstants.siteIdField: siteId},
    );

    final data = response.data as List;
    return {
      for (final item in data)
        (item['assetTypeId'] as int? ?? 0): (item['siteAssetCount'] as int? ?? 0),
    };
  }

  @override
  Future<List<ChecklistItemModel>> getAddAssetChecklist(int assetTypeId) async {
    final response = await client.get(
      ApiConstants.addAssetChecklist,
      queryParameters: {ApiConstants.assetTypeIdField: assetTypeId},
    );

    final data = response.data as Map<String, dynamic>;
    final list = data['assetCheckList'] as List? ?? [];
    return list
        .map((e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createAsset({
    required int assetTypeId,
    required int siteId,
    required List<ChecklistFieldValue> values,
  }) async {
    final createPage = await client.get(
      ApiConstants.assetCreate,
      options: Options(responseType: ResponseType.plain),
    );
    final tokenMatch = _tokenPattern.firstMatch(createPage.data as String);
    if (tokenMatch == null) {
      throw ParsingException('Unable to read the add asset form. Please try again.');
    }

    final formData = <String, dynamic>{
      'AssetId': assetTypeId.toString(),
      'SiteId': siteId.toString(),
      '__RequestVerificationToken': tokenMatch.group(1)!,
    };
    for (var i = 0; i < values.length; i++) {
      formData['PMTicketCheckListData[$i].PMAssetCheckStandardValue'] = values[i].value;
      formData['PMTicketCheckListData[$i].PMAssetChecklabelname'] = values[i].labelName;
      formData['PMTicketCheckListData[$i].PMTicketDetailId'] =
          values[i].pmTicketDetailId.toString();
    }

    final response = await client.post(
      ApiConstants.assetNew,
      data: formData,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (response.statusCode != 302) {
      throw ServerException('Unable to save asset. Please check the form and try again.');
    }
  }

  @override
  Future<void> deleteAsset(int siteAssetId) async {
    final response = await client.get(
      '${ApiConstants.assetDelete}/$siteAssetId',
      options: Options(
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 302) {
      throw ServerException('Unable to delete asset.');
    }
  }
}
