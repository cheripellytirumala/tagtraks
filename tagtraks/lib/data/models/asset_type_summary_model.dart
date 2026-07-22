import '../../domain/entities/asset_type_summary_entity.dart';

class AssetTypeSummaryModel extends AssetTypeSummaryEntity {
  const AssetTypeSummaryModel({
    required super.assetTypeId,
    required super.assetType,
    required super.siteAssetCount,
    super.photoBase64,
  });

  factory AssetTypeSummaryModel.fromJson(Map<String, dynamic> json) {
    return AssetTypeSummaryModel(
      assetTypeId: json['assetTypeId'] as int? ?? 0,
      assetType: json['assetType'] as String? ?? '',
      siteAssetCount: json['siteAssetCount'] as int? ?? 0,
      photoBase64: json['photo'] as String?,
    );
  }
}
