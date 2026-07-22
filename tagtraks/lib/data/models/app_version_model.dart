import '../../domain/entities/app_version_entity.dart';

class AppVersionModel extends AppVersionEntity {
  const AppVersionModel({
    required super.paymentStatus,
    required super.productStatus,
    required super.paymentMessage,
    required super.productMessage,
    required super.apiBaseUrl,
    required super.version,
    required super.appLink,
    required super.deploymentStatus,
    required super.searchRadius,
    required super.distanceRadiusFilters,
    required super.isForcePaymentPage,
    required super.status,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      paymentStatus: json['payment_status'] ?? 0,
      productStatus: json['product_status'] ?? 0,
      paymentMessage: json['payment_message'] ?? '',
      productMessage: json['product_message'] ?? '',
      apiBaseUrl: json['api_base_url'] ?? '',
      version: json['version'] ?? '',
      appLink: json['App_Link'] ?? '',
      deploymentStatus: json['deployment_status']?.toString() ?? '0',
      searchRadius: json['search_radius']?.toString() ?? '0',
      distanceRadiusFilters: (json['distance_radius_filters'] as List?)
              ?.map((e) => int.tryParse(e['radius']?.toString() ?? '0') ?? 0)
              .toList() ??
          [],
      isForcePaymentPage: json['is_force_payment_page']?.toString() ?? '0',
      status: json['status'] ?? 0,
    );
  }

  AppVersionEntity toEntity() {
    return AppVersionEntity(
      paymentStatus: paymentStatus,
      productStatus: productStatus,
      paymentMessage: paymentMessage,
      productMessage: productMessage,
      apiBaseUrl: apiBaseUrl,
      version: version,
      appLink: appLink,
      deploymentStatus: deploymentStatus,
      searchRadius: searchRadius,
      distanceRadiusFilters: distanceRadiusFilters,
      isForcePaymentPage: isForcePaymentPage,
      status: status,
    );
  }
}
