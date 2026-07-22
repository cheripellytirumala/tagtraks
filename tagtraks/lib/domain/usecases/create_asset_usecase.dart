import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/checklist_field_value.dart';
import '../repositories/asset_repository.dart';

class CreateAssetUseCase {
  final AssetRepository repository;

  CreateAssetUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required int assetTypeId,
    required int siteId,
    required List<ChecklistFieldValue> values,
  }) {
    return repository.createAsset(
      assetTypeId: assetTypeId,
      siteId: siteId,
      values: values,
    );
  }
}
