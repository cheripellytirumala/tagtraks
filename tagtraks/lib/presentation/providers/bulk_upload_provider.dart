import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/bulk_upload_result_entity.dart';
import '../../domain/usecases/download_template_usecase.dart';
import '../../domain/usecases/import_assets_usecase.dart';

class BulkUploadProvider with ChangeNotifier {
  final ImportAssetsUseCase importAssetsUseCase;
  final DownloadTemplateUseCase downloadTemplateUseCase;

  BulkUploadProvider(this.importAssetsUseCase, this.downloadTemplateUseCase);

  static const allowedExtensions = ['xlsx', 'xls'];

  String? _fileName;
  String? get fileName => _fileName;

  Uint8List? _fileBytes;
  Uint8List? get fileBytes => _fileBytes;

  String? _fileError;
  String? get fileError => _fileError;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _uploadError;
  String? get uploadError => _uploadError;

  BulkUploadResultEntity? _result;
  BulkUploadResultEntity? get result => _result;

  int? _pendingDuplicateCount;
  int? get pendingDuplicateCount => _pendingDuplicateCount;

  bool _isDownloadingTemplate = false;
  bool get isDownloadingTemplate => _isDownloadingTemplate;

  Uint8List? _templateBytes;
  Uint8List? get templateBytes => _templateBytes;

  void setFile(String fileName, Uint8List bytes) {
    final extension = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
    if (!allowedExtensions.contains(extension)) {
      _fileError = 'Invalid file selected, valid files are of .xlsx,.xls types.';
      _fileName = null;
      _fileBytes = null;
    } else {
      _fileError = null;
      _fileName = fileName;
      _fileBytes = bytes;
    }
    _result = null;
    _pendingDuplicateCount = null;
    _uploadError = null;
    notifyListeners();
  }

  void clearFile() {
    _fileName = null;
    _fileBytes = null;
    _fileError = null;
    notifyListeners();
  }

  Future<void> upload() async {
    if (_fileBytes == null || _fileName == null) {
      _fileError = 'Please choose a file';
      notifyListeners();
      return;
    }

    _isUploading = true;
    _uploadError = null;
    _result = null;
    notifyListeners();

    final result = await importAssetsUseCase(
      fileBytes: _fileBytes!,
      fileName: _fileName!,
      isDuplicateInserted: 0,
    );
    _handleResult(result);
  }

  Future<void> confirmOverwriteDuplicates() async {
    final duplicateCount = _pendingDuplicateCount;
    if (duplicateCount == null || _fileBytes == null || _fileName == null) return;

    _isUploading = true;
    _pendingDuplicateCount = null;
    notifyListeners();

    final result = await importAssetsUseCase(
      fileBytes: _fileBytes!,
      fileName: _fileName!,
      isDuplicateInserted: duplicateCount,
    );
    _handleResult(result);
  }

  void dismissDuplicateConfirm() {
    _pendingDuplicateCount = null;
    notifyListeners();
  }

  void _handleResult(Either<Failure, BulkUploadResultEntity> result) {
    result.fold(
      (failure) {
        _uploadError = failure.message;
        _isUploading = false;
        notifyListeners();
      },
      (data) {
        _isUploading = false;
        if (data.isError) {
          _uploadError = data.statusMessage;
          notifyListeners();
          return;
        }
        _result = data;
        _pendingDuplicateCount = data.duplicateAssetCount > 0 ? data.duplicateAssetCount : null;
        notifyListeners();
      },
    );
  }

  Future<void> downloadTemplate() async {
    _isDownloadingTemplate = true;
    _uploadError = null;
    notifyListeners();

    final result = await downloadTemplateUseCase();
    result.fold(
      (failure) {
        _uploadError = failure.message;
        _isDownloadingTemplate = false;
        notifyListeners();
      },
      (bytes) {
        _templateBytes = bytes;
        _isDownloadingTemplate = false;
        notifyListeners();
      },
    );
  }
}
