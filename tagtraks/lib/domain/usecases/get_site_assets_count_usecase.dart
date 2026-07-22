import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/asset_repository.dart';

class GetSiteAssetsCountUseCase {
  final AssetRepository repository;

  GetSiteAssetsCountUseCase(this.repository);

  Future<Either<Failure, Map<int, int>>> call(int siteId) {
    return repository.getSiteAssetsCount(siteId);
  }
}
