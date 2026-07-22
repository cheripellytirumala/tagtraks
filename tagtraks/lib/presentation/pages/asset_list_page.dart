import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/asset_constants.dart';
import '../../domain/entities/site_asset_entity.dart';
import '../providers/asset_list_provider.dart';
import '../widgets/base64_asset_image.dart';

class AssetListPage extends StatefulWidget {
  final VoidCallback? onAddAssetTap;

  const AssetListPage({super.key, this.onAddAssetTap});

  @override
  State<AssetListPage> createState() => _AssetListPageState();
}

class _AssetListPageState extends State<AssetListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetListProvider>().init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Asset List'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
        actions: [
          TextButton.icon(
            onPressed: widget.onAddAssetTap,
            icon: const Icon(Icons.add, color: AppColors.white),
            label: const Text('Add', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
      body: Consumer<AssetListProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: DropdownButtonFormField<int>(
                  initialValue: provider.selectedSiteId,
                  decoration: const InputDecoration(
                    labelText: 'Office',
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(),
                  ),
                  items: AssetConstants.sites
                      .map((site) => DropdownMenuItem(value: site.id, child: Text(site.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) provider.changeSite(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Owner or ID',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: provider.updateSearch,
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: AssetConstants.assetTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final type = AssetConstants.assetTypes[index];
                    final selected = provider.selectedAssetTypeId == type.id;
                    return ChoiceChip(
                      label: Text('${type.name} (${provider.countFor(type.id)})'),
                      selected: selected,
                      selectedColor: AppColors.primaryNavy,
                      labelStyle: TextStyle(
                        color: selected ? AppColors.white : AppColors.primaryNavy,
                      ),
                      onSelected: (_) => provider.fetchAssets(type.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _AssetListBody(provider: provider)),
            ],
          );
        },
      ),
    );
  }
}

class _AssetListBody extends StatelessWidget {
  final AssetListProvider provider;

  const _AssetListBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoadingAssets) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }

    final assets = provider.filteredAssets;
    if (assets.isEmpty) {
      return const Center(child: Text('No assets found'));
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchAssets(provider.selectedAssetTypeId),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: assets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final asset = assets[index];
          return _AssetListTile(
            asset: asset,
            onDelete: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Delete Asset'),
                  content: Text('Delete "${asset.siteAssetName}"? This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await provider.deleteAsset(asset.siteAssetId);
              }
            },
          );
        },
      ),
    );
  }
}

class _AssetListTile extends StatelessWidget {
  final SiteAssetEntity asset;
  final VoidCallback onDelete;

  const _AssetListTile({required this.asset, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Base64AssetImage(base64: asset.siteAssetImageBase64),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.siteAssetName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('id: ${asset.assetUniqueId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Brand: ${asset.brand}', style: const TextStyle(fontSize: 12)),
                Text('User: ${asset.user}', style: const TextStyle(fontSize: 12)),
                Text('Status: ${asset.status}', style: const TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
