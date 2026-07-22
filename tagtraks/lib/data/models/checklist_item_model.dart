import '../../domain/entities/checklist_item_entity.dart';

class ChecklistItemModel extends ChecklistItemEntity {
  const ChecklistItemModel({
    required super.pmTicketDetailId,
    required super.labelName,
    required super.labelType,
    required super.isRequired,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      pmTicketDetailId: json['pmAssetCheckListDetailId'] as int? ?? 0,
      labelName: json['checklistLabelName'] as String? ?? '',
      labelType: json['checklistLabelType'] as String? ?? 'TextBox',
      isRequired: json['isRequired'] == true ||
          json['isRequired']?.toString().toLowerCase() == 'true',
    );
  }
}
