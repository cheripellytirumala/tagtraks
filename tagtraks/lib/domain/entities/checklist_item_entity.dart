import 'package:equatable/equatable.dart';

class ChecklistItemEntity extends Equatable {
  final int pmTicketDetailId;
  final String labelName;
  final String labelType;
  final bool isRequired;

  const ChecklistItemEntity({
    required this.pmTicketDetailId,
    required this.labelName,
    required this.labelType,
    required this.isRequired,
  });

  @override
  List<Object?> get props => [pmTicketDetailId, labelName, labelType, isRequired];
}
