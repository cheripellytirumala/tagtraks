import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/bulk_upload_result_entity.dart';
import '../../domain/repositories/bulk_upload_repository.dart';
import '../data_sources/remote/bulk_upload_remote_data_source.dart';

class BulkUploadRepositoryImpl implements BulkUploadRepository {
  final BulkUploadRemoteDataSource remoteDataSource;

  BulkUploadRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BulkUploadResultEntity>> importAssets({
    required Uint8List fileBytes,
    required String fileName,
    required int isDuplicateInserted,
  }) async {
    try {
      final model = await remoteDataSource.importAssets(
        fileBytes: fileBytes,
        fileName: fileName,
        isDuplicateInserted: isDuplicateInserted,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> downloadTemplate() async {
    try {
      final bytes = await remoteDataSource.downloadTemplate();
      return Right(bytes);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
