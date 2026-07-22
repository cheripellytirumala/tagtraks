import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../core/constants/asset_constants.dart';
import '../../domain/entities/checklist_field_value.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/usecases/create_asset_usecase.dart';
import '../../domain/usecases/get_add_asset_checklist_usecase.dart';

class AddAssetProvider with ChangeNotifier {
  final GetAddAssetChecklistUseCase getAddAssetChecklistUseCase;
  final CreateAssetUseCase createAssetUseCase;

  AddAssetProvider(this.getAddAssetChecklistUseCase, this.createAssetUseCase);

  int _assetTypeId = AssetConstants.assetTypes.first.id;
  int get assetTypeId => _assetTypeId;

  int _siteId = AssetConstants.sites.first.id;
  int get siteId => _siteId;

  bool _isLoadingChecklist = false;
  bool get isLoadingChecklist => _isLoadingChecklist;

  String? _checklistError;
  String? get checklistError => _checklistError;

  List<ChecklistItemEntity> _checklist = [];
  List<ChecklistItemEntity> get checklist => _checklist;

  final Map<int, String> _textValues = {};
  final Map<int, Uint8List> _imageValues = {};

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _submitError;
  String? get submitError => _submitError;

  Future<void> init() => selectAssetType(_assetTypeId);

  Future<void> selectAssetType(int assetTypeId) async {
    _assetTypeId = assetTypeId;
    _textValues.clear();
    _imageValues.clear();
    _isLoadingChecklist = true;
    _checklistError = null;
    notifyListeners();

    final result = await getAddAssetChecklistUseCase(assetTypeId);
    result.fold(
      (failure) {
        _checklistError = failure.message;
        _checklist = [];
        _isLoadingChecklist = false;
        notifyListeners();
      },
      (data) {
        _checklist = data;
        for (final item in data) {
          if (item.labelType == 'TextBox' && item.labelName == 'Location') {
            _textValues[item.pmTicketDetailId] = 'C1';
          }
        }
        _isLoadingChecklist = false;
        notifyListeners();
      },
    );
  }

  void selectSite(int siteId) {
    _siteId = siteId;
    notifyListeners();
  }

  String textValueFor(int pmTicketDetailId) => _textValues[pmTicketDetailId] ?? '';

  void updateTextValue(int pmTicketDetailId, String value) {
    _textValues[pmTicketDetailId] = value;
  }

  Uint8List? imageValueFor(int pmTicketDetailId) => _imageValues[pmTicketDetailId];

  void updateImageValue(int pmTicketDetailId, Uint8List bytes) {
    _imageValues[pmTicketDetailId] = bytes;
    notifyListeners();
  }

  Future<bool> submit() async {
    _isSubmitting = true;
    _submitError = null;
    notifyListeners();

    final values = _checklist.map((item) {
      if (item.labelType == 'Image') {
        final bytes = _imageValues[item.pmTicketDetailId];
        return ChecklistFieldValue(
          pmTicketDetailId: item.pmTicketDetailId,
          labelName: item.labelName,
          value: bytes == null ? '' : base64Encode(bytes),
        );
      }

      final raw = _textValues[item.pmTicketDetailId]?.trim() ?? '';
      final value = raw.isEmpty && !item.isRequired ? 'Not Applicable' : raw;
      return ChecklistFieldValue(
        pmTicketDetailId: item.pmTicketDetailId,
        labelName: item.labelName,
        value: value,
      );
    }).toList();

    final missingRequired = _checklist.where(
      (item) => item.isRequired && (_textValues[item.pmTicketDetailId]?.trim().isEmpty ?? true) && item.labelType != 'Image',
    );
    if (missingRequired.isNotEmpty) {
      _submitError = 'Please fill in: ${missingRequired.map((e) => e.labelName).join(', ')}';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }

    final result = await createAssetUseCase(
      assetTypeId: _assetTypeId,
      siteId: _siteId,
      values: values,
    );

    return result.fold(
      (failure) {
        _submitError = failure.message;
        _isSubmitting = false;
        notifyListeners();
        return false;
      },
      (_) {
        _isSubmitting = false;
        _textValues.clear();
        _imageValues.clear();
        notifyListeners();
        return true;
      },
    );
  }
}
