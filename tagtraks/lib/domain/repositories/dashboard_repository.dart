import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/dashboard_summary_entity.dart';
import '../entities/site_asset_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary();
  Future<Either<Failure, List<SiteAssetEntity>>> getSiteAssets(
    int assetTypeId, {
    int? siteId,
  });
}
