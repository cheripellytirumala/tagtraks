import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/site_asset_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetSiteAssetsUseCase {
  final DashboardRepository repository;

  GetSiteAssetsUseCase(this.repository);

  Future<Either<Failure, List<SiteAssetEntity>>> call(
    int assetTypeId, {
    int? siteId,
  }) {
    return repository.getSiteAssets(assetTypeId, siteId: siteId);
  }
}
