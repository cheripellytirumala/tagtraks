import 'package:flutter/material.dart';
import '../../core/constants/asset_constants.dart';
import '../../domain/entities/site_asset_entity.dart';
import '../../domain/usecases/delete_asset_usecase.dart';
import '../../domain/usecases/get_site_assets_count_usecase.dart';
import '../../domain/usecases/get_site_assets_usecase.dart';

class AssetListProvider with ChangeNotifier {
  final GetSiteAssetsCountUseCase getSiteAssetsCountUseCase;
  final GetSiteAssetsUseCase getSiteAssetsUseCase;
  final DeleteAssetUseCase deleteAssetUseCase;

  AssetListProvider(
    this.getSiteAssetsCountUseCase,
    this.getSiteAssetsUseCase,
    this.deleteAssetUseCase,
  );

  int _selectedSiteId = AssetConstants.sites.first.id;
  int get selectedSiteId => _selectedSiteId;

  int _selectedAssetTypeId = AssetConstants.assetTypes.first.id;
  int get selectedAssetTypeId => _selectedAssetTypeId;

  Map<int, int> _counts = {};
  int countFor(int assetTypeId) => _counts[assetTypeId] ?? 0;

  bool _isLoadingCounts = false;
  bool get isLoadingCounts => _isLoadingCounts;

  bool _isLoadingAssets = false;
  bool get isLoadingAssets => _isLoadingAssets;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<SiteAssetEntity> _assets = [];
  String _searchQuery = '';

  List<SiteAssetEntity> get filteredAssets {
    if (_searchQuery.isEmpty) return _assets;
    final query = _searchQuery.toLowerCase();
    return _assets
        .where((asset) =>
            asset.user.toLowerCase().contains(query) ||
            asset.assetUniqueId.toLowerCase().contains(query))
        .toList();
  }

  Future<void> init() async {
    await fetchCounts();
    await fetchAssets(_selectedAssetTypeId);
  }

  Future<void> changeSite(int siteId) async {
    if (siteId == _selectedSiteId) return;
    _selectedSiteId = siteId;
    notifyListeners();
    await fetchCounts();
    await fetchAssets(_selectedAssetTypeId);
  }

  Future<void> fetchCounts() async {
    _isLoadingCounts = true;
    notifyListeners();

    final result = await getSiteAssetsCountUseCase(_selectedSiteId);
    result.fold(
      (failure) {
        _isLoadingCounts = false;
        notifyListeners();
      },
      (data) {
        _counts = data;
        _isLoadingCounts = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchAssets(int assetTypeId) async {
    _selectedAssetTypeId = assetTypeId;
    _isLoadingAssets = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getSiteAssetsUseCase(assetTypeId, siteId: _selectedSiteId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _assets = [];
        _isLoadingAssets = false;
        notifyListeners();
      },
      (data) {
        _assets = data;
        _isLoadingAssets = false;
        notifyListeners();
      },
    );
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> deleteAsset(int siteAssetId) async {
    final result = await deleteAssetUseCase(siteAssetId);
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _assets = _assets.where((a) => a.siteAssetId != siteAssetId).toList();
        notifyListeners();
        fetchCounts();
        return true;
      },
    );
  }
}
