import '../../domain/entities/bulk_upload_result_entity.dart';

class BulkUploadResultModel extends BulkUploadResultEntity {
  const BulkUploadResultModel({
    required super.isError,
    required super.statusMessage,
    required super.duplicateAssetCount,
    required super.skippedRecordsCount,
    required super.insertedRecordsCount,
    required super.updatedAssetCount,
  });

  factory BulkUploadResultModel.fromJson(Map<String, dynamic> json) {
    return BulkUploadResultModel(
      isError: json['isError'] == true,
      statusMessage: json['statusMessage'] as String? ?? '',
      duplicateAssetCount: json['duplicateAssetCount'] as int? ?? 0,
      skippedRecordsCount: json['skippedRecordsCount'] as int? ?? 0,
      insertedRecordsCount: json['insertedRecordsCount'] as int? ?? 0,
      updatedAssetCount: json['updatedAssetCount'] as int? ?? 0,
    );
  }
}
