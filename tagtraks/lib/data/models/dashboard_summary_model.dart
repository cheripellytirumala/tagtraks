import '../../domain/entities/dashboard_summary_entity.dart';
import 'asset_type_summary_model.dart';

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.userAccountId,
    required super.totalUsers,
    required super.totalAssets,
    required super.ticketsOpen,
    required super.ticketsClosed,
    required super.ticketsPending,
    required super.ticketsOverdue,
    required List<AssetTypeSummaryModel> super.assetTypes,
  });
}
