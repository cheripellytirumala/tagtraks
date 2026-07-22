import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/bulk_upload_result_entity.dart';

abstract class BulkUploadRepository {
  Future<Either<Failure, BulkUploadResultEntity>> importAssets({
    required Uint8List fileBytes,
    required String fileName,
    required int isDuplicateInserted,
  });

  Future<Either<Failure, Uint8List>> downloadTemplate();
}
