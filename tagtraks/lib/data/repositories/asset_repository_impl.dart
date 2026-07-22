import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/checklist_field_value.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/repositories/asset_repository.dart';
import '../data_sources/remote/asset_remote_data_source.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource remoteDataSource;

  AssetRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<int, int>>> getSiteAssetsCount(int siteId) async {
    try {
      final data = await remoteDataSource.getSiteAssetsCount(siteId);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChecklistItemEntity>>> getAddAssetChecklist(
    int assetTypeId,
  ) async {
    try {
      final data = await remoteDataSource.getAddAssetChecklist(assetTypeId);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createAsset({
    required int assetTypeId,
    required int siteId,
    required List<ChecklistFieldValue> values,
  }) async {
    try {
      await remoteDataSource.createAsset(
        assetTypeId: assetTypeId,
        siteId: siteId,
        values: values,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAsset(int siteAssetId) async {
    try {
      await remoteDataSource.deleteAsset(siteAssetId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
