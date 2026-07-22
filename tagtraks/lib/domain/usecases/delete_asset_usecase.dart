import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/asset_repository.dart';

class DeleteAssetUseCase {
  final AssetRepository repository;

  DeleteAssetUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int siteAssetId) {
    return repository.deleteAsset(siteAssetId);
  }
}
