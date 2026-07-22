import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/bulk_upload_result_entity.dart';
import '../providers/bulk_upload_provider.dart';

class BulkUploadPage extends StatefulWidget {
  const BulkUploadPage({super.key});

  @override
  State<BulkUploadPage> createState() => _BulkUploadPageState();
}

class _BulkUploadPageState extends State<BulkUploadPage> {
  Future<void> _chooseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: BulkUploadProvider.allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty || !mounted) return;

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return;

    context.read<BulkUploadProvider>().setFile(file.name, bytes);
  }

  Future<void> _downloadTemplate() async {
    final provider = context.read<BulkUploadProvider>();
    await provider.downloadTemplate();
    if (!mounted) return;
    final bytes = provider.templateBytes;
    if (bytes == null) return;
    await Share.shareXFiles([
      XFile.fromData(
        bytes,
        name: 'AssetImportTemplate.xlsx',
        mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bulk Upload'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
      ),
      body: Consumer<BulkUploadProvider>(
        builder: (context, provider, child) {
          if (provider.pendingDuplicateCount != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showDuplicateConfirmDialog(context, provider);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primaryNavy),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Upload asset list. Only .xlsx and .xls files are supported.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: provider.isDownloadingTemplate ? null : _downloadTemplate,
                  icon: provider.isDownloadingTemplate
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined),
                  label: const Text('Download Sample Excel'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Upload asset list',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.greyBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.fileName ?? 'No file chosen',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: provider.fileName == null ? Colors.grey : AppColors.primaryNavy,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _chooseFile,
                        child: const Text('Choose File'),
                      ),
                    ],
                  ),
                ),
                if (provider.fileError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    provider.fileError!,
                    style: const TextStyle(color: AppColors.errorText, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 24),
                if (provider.uploadError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      provider.uploadError!,
                      style: const TextStyle(color: AppColors.errorText),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (provider.result != null && provider.pendingDuplicateCount == null) ...[
                  _ResultSummary(result: provider.result!),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: provider.isUploading ? null : provider.clearFile,
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: provider.isUploading ? null : provider.upload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          foregroundColor: AppColors.white,
                        ),
                        child: provider.isUploading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDuplicateConfirmDialog(BuildContext context, BulkUploadProvider provider) {
    final duplicateCount = provider.pendingDuplicateCount;
    if (duplicateCount == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Duplicate Records Found'),
        content: Text(
          provider.result?.statusMessage ??
              '$duplicateCount duplicate record(s) were found. Overwrite them?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              provider.dismissDuplicateConfirm();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              provider.confirmOverwriteDuplicates();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  final BulkUploadResultEntity result;

  const _ResultSummary({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skipped records (Missing Asset Tag/Serial Number): ${result.skippedRecordsCount}',
            style: TextStyle(color: Colors.green.shade800, fontSize: 13),
          ),
          Text(
            'Inserted records: ${result.insertedRecordsCount}',
            style: TextStyle(color: Colors.green.shade800, fontSize: 13),
          ),
          Text(
            'Updated records: ${result.updatedAssetCount}',
            style: TextStyle(color: Colors.green.shade800, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
