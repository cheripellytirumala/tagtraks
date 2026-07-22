import '../../domain/entities/site_asset_entity.dart';

class SiteAssetModel extends SiteAssetEntity {
  const SiteAssetModel({
    required super.siteAssetId,
    required super.assetUniqueId,
    required super.siteAssetName,
    required super.brand,
    required super.user,
    required super.status,
    super.siteAssetImageBase64,
    super.assetQRCodeBase64,
  });

  factory SiteAssetModel.fromJson(Map<String, dynamic> json) {
    return SiteAssetModel(
      siteAssetId: json['siteAssetId'] as int? ?? 0,
      assetUniqueId: json['assetUniqueId']?.toString() ?? '',
      siteAssetName: json['siteAssetName'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      user: json['user'] as String? ?? '',
      status: json['status'] as String? ?? '',
      siteAssetImageBase64: json['siteAssetImage'] as String?,
      assetQRCodeBase64: json['assetQRCode'] as String?,
    );
  }
}
