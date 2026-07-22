import 'package:equatable/equatable.dart';
import 'asset_type_summary_entity.dart';

class DashboardSummaryEntity extends Equatable {
  final int userAccountId;
  final int totalUsers;
  final int totalAssets;
  final int ticketsOpen;
  final int ticketsClosed;
  final int ticketsPending;
  final int ticketsOverdue;
  final List<AssetTypeSummaryEntity> assetTypes;

  const DashboardSummaryEntity({
    required this.userAccountId,
    required this.totalUsers,
    required this.totalAssets,
    required this.ticketsOpen,
    required this.ticketsClosed,
    required this.ticketsPending,
    required this.ticketsOverdue,
    required this.assetTypes,
  });

  @override
  List<Object?> get props => [
        userAccountId,
        totalUsers,
        totalAssets,
        ticketsOpen,
        ticketsClosed,
        ticketsPending,
        ticketsOverdue,
        assetTypes,
      ];
}
