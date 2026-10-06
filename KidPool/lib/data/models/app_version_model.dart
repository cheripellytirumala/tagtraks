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
    super.userDetailsFlag,
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
      deploymentStatus: json['deployment_status'] ?? '',
      userDetailsFlag: json['user_details_flag'],
      searchRadius: json['search_radius'] ?? '0',
      distanceRadiusFilters: (json['distance_radius_filters'] as List? ?? [])
          .map((i) => RadiusModel.fromJson(i))
          .toList(),
      isForcePaymentPage: json['is_force_payment_page'] ?? '0',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_status': paymentStatus,
      'product_status': productStatus,
      'payment_message': paymentMessage,
      'product_message': productMessage,
      'api_base_url': apiBaseUrl,
      'version': version,
      'App_Link': appLink,
      'deployment_status': deploymentStatus,
      'user_details_flag': userDetailsFlag,
      'search_radius': searchRadius,
      'distance_radius_filters': (distanceRadiusFilters as List<RadiusModel>)
          .map((i) => i.toJson())
          .toList(),
      'is_force_payment_page': isForcePaymentPage,
      'status': status,
    };
  }
}

class RadiusModel extends RadiusEntity {
  const RadiusModel({required super.radius});

  factory RadiusModel.fromJson(Map<String, dynamic> json) {
    return RadiusModel(
      radius: json['radius'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'radius': radius,
    };
  }
}
