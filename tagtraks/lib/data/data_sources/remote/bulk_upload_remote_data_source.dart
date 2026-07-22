import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/bulk_upload_result_model.dart';

abstract class BulkUploadRemoteDataSource {
  Future<BulkUploadResultModel> importAssets({
    required Uint8List fileBytes,
    required String fileName,
    required int isDuplicateInserted,
  });

  Future<Uint8List> downloadTemplate();
}

class BulkUploadRemoteDataSourceImpl implements BulkUploadRemoteDataSource {
  final ApiClient client;

  BulkUploadRemoteDataSourceImpl(this.client);

  static final _tokenPattern = RegExp(
    r'name="__RequestVerificationToken"[^>]*value="([^"]+)"',
  );

  @override
  Future<BulkUploadResultModel> importAssets({
    required Uint8List fileBytes,
    required String fileName,
    required int isDuplicateInserted,
  }) async {
    // Best-effort antiforgery token: the page's own JS doesn't attach one to
    // this AJAX call, but including it (if present) is harmless if the
    // endpoint does enforce it.
    String? token;
    try {
      final page = await client.get(
        ApiConstants.importExport,
        options: Options(responseType: ResponseType.plain),
      );
      token = _tokenPattern.firstMatch(page.data as String)?.group(1);
    } catch (_) {
      token = null;
    }

    final formData = FormData.fromMap({
      fileName: MultipartFile.fromBytes(fileBytes, filename: fileName),
      'IsDuplicateInserted': isDuplicateInserted.toString(),
      if (token != null) ApiConstants.verificationTokenField: token,
    });

    final response = await client.post(ApiConstants.importAssets, data: formData);
    return BulkUploadResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Uint8List> downloadTemplate() async {
    final response = await client.get(
      ApiConstants.downloadTemplate,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data as List<int>);
  }
}
