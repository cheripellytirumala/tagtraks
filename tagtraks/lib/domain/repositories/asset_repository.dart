import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/checklist_field_value.dart';
import '../entities/checklist_item_entity.dart';

abstract class AssetRepository {
  Future<Either<Failure, Map<int, int>>> getSiteAssetsCount(int siteId);
  Future<Either<Failure, List<ChecklistItemEntity>>> getAddAssetChecklist(int assetTypeId);
  Future<Either<Failure, Unit>> createAsset({
    required int assetTypeId,
    required int siteId,
    required List<ChecklistFieldValue> values,
  });
  Future<Either<Failure, Unit>> deleteAsset(int siteAssetId);
}
