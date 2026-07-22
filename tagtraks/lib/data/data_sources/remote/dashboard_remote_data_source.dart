import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/asset_type_summary_model.dart';
import '../../models/dashboard_summary_model.dart';
import '../../models/site_asset_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary();
  Future<List<SiteAssetModel>> getSiteAssets(int assetTypeId, {int? siteId});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl(this.client);

  static final _totalUsersPattern = RegExp(
    r'Total Users</span>\s*<div class="count"><a[^>]*>(\d+)</a>',
  );
  static final _totalAssetsPattern = RegExp(
    r'Total Assets Count</span>\s*<div class="count orange"><a[^>]*>(\d+)</a>',
  );
  static final _badgeOpenPattern = RegExp(r'badge-open">(\d+)<');
  static final _badgeClosedPattern = RegExp(r'badge-closed">(\d+)<');
  static final _badgePendingPattern = RegExp(r'badge-pending">(\d+)<');
  static final _badgeOverduePattern = RegExp(r'badge-overdue">(\d+)<');
  static final _assetListDataPattern = RegExp(
    r'var assetListData\s*=\s*(\[.*?\]);',
    dotAll: true,
  );
  static final _userAccountIdPattern = RegExp(
    r'href="/Account/Viewprofile/(\d+)"',
  );

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    final response = await client.get(
      ApiConstants.dashboard,
      options: Options(responseType: ResponseType.plain),
    );
    final html = response.data as String;

    int intOf(RegExp pattern) =>
        int.tryParse(pattern.firstMatch(html)?.group(1) ?? '0') ?? 0;

    final assetListMatch = _assetListDataPattern.firstMatch(html);
    final assetTypes = assetListMatch == null
        ? <AssetTypeSummaryModel>[]
        : (jsonDecode(assetListMatch.group(1)!) as List)
            .map((e) => AssetTypeSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList();

    return DashboardSummaryModel(
      userAccountId: intOf(_userAccountIdPattern),
      totalUsers: intOf(_totalUsersPattern),
      totalAssets: intOf(_totalAssetsPattern),
      ticketsOpen: intOf(_badgeOpenPattern),
      ticketsClosed: intOf(_badgeClosedPattern),
      ticketsPending: intOf(_badgePendingPattern),
      ticketsOverdue: intOf(_badgeOverduePattern),
      assetTypes: assetTypes,
    );
  }

  @override
  Future<List<SiteAssetModel>> getSiteAssets(int assetTypeId, {int? siteId}) async {
    final response = await client.get(
      ApiConstants.siteAssets,
      queryParameters: {
        ApiConstants.assetTypeIdField: assetTypeId,
        if (siteId != null) ApiConstants.siteIdField: siteId,
      },
    );

    final data = response.data as List;
    return data
        .map((e) => SiteAssetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
