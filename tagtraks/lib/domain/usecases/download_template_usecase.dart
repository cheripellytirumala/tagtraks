import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/bulk_upload_repository.dart';

class DownloadTemplateUseCase {
  final BulkUploadRepository repository;

  DownloadTemplateUseCase(this.repository);

  Future<Either<Failure, Uint8List>> call() {
    return repository.downloadTemplate();
  }
}
