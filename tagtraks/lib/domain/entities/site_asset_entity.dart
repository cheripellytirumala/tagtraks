import 'package:equatable/equatable.dart';

class SiteAssetEntity extends Equatable {
  final int siteAssetId;
  final String assetUniqueId;
  final String siteAssetName;
  final String brand;
  final String user;
  final String status;
  final String? siteAssetImageBase64;
  final String? assetQRCodeBase64;

  const SiteAssetEntity({
    required this.siteAssetId,
    required this.assetUniqueId,
    required this.siteAssetName,
    required this.brand,
    required this.user,
    required this.status,
    this.siteAssetImageBase64,
    this.assetQRCodeBase64,
  });

  @override
  List<Object?> get props => [
        siteAssetId,
        assetUniqueId,
        siteAssetName,
        brand,
        user,
        status,
        siteAssetImageBase64,
        assetQRCodeBase64,
      ];
}
