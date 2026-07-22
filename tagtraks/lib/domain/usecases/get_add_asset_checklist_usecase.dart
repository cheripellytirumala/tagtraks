import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/checklist_item_entity.dart';
import '../repositories/asset_repository.dart';

class GetAddAssetChecklistUseCase {
  final AssetRepository repository;

  GetAddAssetChecklistUseCase(this.repository);

  Future<Either<Failure, List<ChecklistItemEntity>>> call(int assetTypeId) {
    return repository.getAddAssetChecklist(assetTypeId);
  }
}
