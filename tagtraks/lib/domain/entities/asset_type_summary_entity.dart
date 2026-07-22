import 'package:equatable/equatable.dart';

class AssetTypeSummaryEntity extends Equatable {
  final int assetTypeId;
  final String assetType;
  final int siteAssetCount;
  final String? photoBase64;

  const AssetTypeSummaryEntity({
    required this.assetTypeId,
    required this.assetType,
    required this.siteAssetCount,
    this.photoBase64,
  });

  @override
  List<Object?> get props => [assetTypeId, assetType, siteAssetCount, photoBase64];
}
