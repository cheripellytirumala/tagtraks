import 'package:equatable/equatable.dart';

class BulkUploadResultEntity extends Equatable {
  final bool isError;
  final String statusMessage;
  final int duplicateAssetCount;
  final int skippedRecordsCount;
  final int insertedRecordsCount;
  final int updatedAssetCount;

  const BulkUploadResultEntity({
    required this.isError,
    required this.statusMessage,
    required this.duplicateAssetCount,
    required this.skippedRecordsCount,
    required this.insertedRecordsCount,
    required this.updatedAssetCount,
  });

  @override
  List<Object?> get props => [
        isError,
        statusMessage,
        duplicateAssetCount,
        skippedRecordsCount,
        insertedRecordsCount,
        updatedAssetCount,
      ];
}
