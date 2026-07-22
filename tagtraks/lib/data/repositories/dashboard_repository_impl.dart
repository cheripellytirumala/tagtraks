import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/site_asset_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/remote/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary() async {
    try {
      final model = await remoteDataSource.getDashboardSummary();
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SiteAssetEntity>>> getSiteAssets(
    int assetTypeId, {
    int? siteId,
  }) async {
    try {
      final models = await remoteDataSource.getSiteAssets(assetTypeId, siteId: siteId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
