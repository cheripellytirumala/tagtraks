import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/asset_type_summary_entity.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/site_asset_entity.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/base64_asset_image.dart';
import 'login_page.dart';
import 'profile_page.dart';

enum _DashboardMenuAction { viewProfile, logout }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
        actions: [
          PopupMenuButton<_DashboardMenuAction>(
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (action) {
              switch (action) {
                case _DashboardMenuAction.viewProfile:
                  final userAccountId =
                      context.read<DashboardProvider>().summary?.userAccountId;
                  if (userAccountId == null || userAccountId == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile info is still loading, please try again')),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(userAccountId: userAccountId),
                    ),
                  );
                  break;
                case _DashboardMenuAction.logout:
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _DashboardMenuAction.viewProfile,
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('View Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: _DashboardMenuAction.logout,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.summary == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.summary == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: AppColors.errorText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.fetchDashboardSummary,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final summary = provider.summary;
          if (summary == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: provider.fetchDashboardSummary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people_outline,
                          label: 'Total Users',
                          value: summary.totalUsers.toString(),
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.inventory_2_outlined,
                          label: 'Total Assets',
                          value: summary.totalAssets.toString(),
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TicketsCard(summary: summary),
                  const SizedBox(height: 24),
                  const Text(
                    'Asset Groups',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _AssetGroupTabs(assetTypes: summary.assetTypes),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _TicketsCard extends StatelessWidget {
  final DashboardSummaryEntity summary;

  const _TicketsCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tickets',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _TicketBadge(label: 'Open', value: summary.ticketsOpen, color: Colors.blue),
              const SizedBox(width: 12),
              _TicketBadge(label: 'Closed', value: summary.ticketsClosed, color: Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _TicketBadge(label: 'Pending', value: summary.ticketsPending, color: Colors.amber),
              const SizedBox(width: 12),
              _TicketBadge(label: 'Overdue', value: summary.ticketsOverdue, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _TicketBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            child: Text(
              value.toString(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AssetGroupTabs extends StatefulWidget {
  final List<AssetTypeSummaryEntity> assetTypes;

  const _AssetGroupTabs({required this.assetTypes});

  @override
  State<_AssetGroupTabs> createState() => _AssetGroupTabsState();
}

class _AssetGroupTabsState extends State<_AssetGroupTabs> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.assetTypes.isNotEmpty) {
      _controller = TabController(length: widget.assetTypes.length, vsync: this);
      _controller!.addListener(_onTabChanged);
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAssetsForTab(0));
    }
  }

  void _onTabChanged() {
    if (_controller == null || _controller!.indexIsChanging) return;
    _loadAssetsForTab(_controller!.index);
  }

  void _loadAssetsForTab(int index) {
    final assetTypeId = widget.assetTypes[index].assetTypeId;
    context.read<DashboardProvider>().fetchSiteAssets(assetTypeId);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetTypes.isEmpty || _controller == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('No asset groups found')),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _controller,
            isScrollable: true,
            labelColor: AppColors.primaryNavy,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryNavy,
            tabs: widget.assetTypes.map((type) {
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.assetType),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        type.siteAssetCount.toString(),
                        style: const TextStyle(fontSize: 11, color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 360,
          child: TabBarView(
            controller: _controller,
            children: widget.assetTypes.map((_) => const _AssetDetailsList()).toList(),
          ),
        ),
      ],
    );
  }
}

class _AssetDetailsList extends StatelessWidget {
  const _AssetDetailsList();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingAssets) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.assetsError != null) {
          return Center(child: Text(provider.assetsError!));
        }
        if (provider.siteAssets.isEmpty) {
          return const Center(child: Text('No assets found'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: provider.siteAssets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _AssetTile(asset: provider.siteAssets[index]),
        );
      },
    );
  }
}

class _AssetTile extends StatelessWidget {
  final SiteAssetEntity asset;

  const _AssetTile({required this.asset});

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
        ],
      ),
    );
  }
}
