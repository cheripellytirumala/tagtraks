import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/bulk_upload_result_entity.dart';
import '../repositories/bulk_upload_repository.dart';

class ImportAssetsUseCase {
  final BulkUploadRepository repository;

  ImportAssetsUseCase(this.repository);

  Future<Either<Failure, BulkUploadResultEntity>> call({
    required Uint8List fileBytes,
    required String fileName,
    required int isDuplicateInserted,
  }) {
    return repository.importAssets(
      fileBytes: fileBytes,
      fileName: fileName,
      isDuplicateInserted: isDuplicateInserted,
    );
  }
}
