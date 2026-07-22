import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/asset_constants.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../providers/add_asset_provider.dart';
import 'bulk_upload_page.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final Map<int, TextEditingController> _controllers = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddAssetProvider>().init();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _clearControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  TextEditingController _controllerFor(int id, String initialValue) {
    return _controllers.putIfAbsent(
        id, () => TextEditingController(text: initialValue));
  }

  Future<void> _pickImage(int pmTicketDetailId) async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null || !mounted) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    context.read<AddAssetProvider>().updateImageValue(pmTicketDetailId, bytes);
  }

  Future<void> _pickDate(int pmTicketDetailId) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    final formatted =
        '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    _controllerFor(pmTicketDetailId, '').text = formatted;
    context
        .read<AddAssetProvider>()
        .updateTextValue(pmTicketDetailId, formatted);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate bottom padding based on the custom navigation bar height + system padding
    final double navBarHeight = 80.0 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Asset'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BulkUploadPage()),
            ),
            icon: const Icon(Icons.upload_file, color: AppColors.white),
            label: const Text('Bulk Upload', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
      body: Consumer<AddAssetProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, navBarHeight + 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  value: provider.assetTypeId,
                  decoration: const InputDecoration(
                    labelText: 'Type of Item *',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                  items: AssetConstants.assetTypes
                      .map((type) => DropdownMenuItem(
                          value: type.id, child: Text(type.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    _clearControllers();
                    provider.selectAssetType(value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: provider.siteId,
                  decoration: const InputDecoration(
                    labelText: 'Office *',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                  items: AssetConstants.sites
                      .map((site) => DropdownMenuItem(
                          value: site.id, child: Text(site.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) provider.selectSite(value);
                  },
                ),
                const SizedBox(height: 24),
                if (provider.isLoadingChecklist)
                  const Center(child: CircularProgressIndicator())
                else if (provider.checklistError != null)
                  Text(provider.checklistError!,
                      style: const TextStyle(color: AppColors.errorText))
                else
                  ...provider.checklist.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _ChecklistField(
                        item: item,
                        provider: provider,
                        controllerFor: _controllerFor,
                        onPickImage: () => _pickImage(item.pmTicketDetailId),
                        onPickDate: () => _pickDate(item.pmTicketDetailId),
                      ),
                    ),
                  ),
                if (provider.submitError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      provider.submitError!,
                      style: const TextStyle(color: AppColors.errorText),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: provider.isSubmitting
                        ? null
                        : () async {
                            final success = await provider.submit();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Asset added successfully')),
                              );
                              _clearControllers();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: provider.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: AppColors.white, strokeWidth: 2),
                          )
                        : const Text('Save Asset',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChecklistField extends StatelessWidget {
  final ChecklistItemEntity item;
  final AddAssetProvider provider;
  final TextEditingController Function(int, String) controllerFor;
  final VoidCallback onPickImage;
  final VoidCallback onPickDate;

  const _ChecklistField({
    required this.item,
    required this.provider,
    required this.controllerFor,
    required this.onPickImage,
    required this.onPickDate,
  });

  String get _label => item.isRequired ? '${item.labelName} *' : item.labelName;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: _label,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: AppColors.white,
    );

    switch (item.labelType) {
      case 'Textarea':
        return TextFormField(
          controller: controllerFor(item.pmTicketDetailId,
              provider.textValueFor(item.pmTicketDetailId)),
          maxLines: 3,
          decoration: decoration,
          onChanged: (value) =>
              provider.updateTextValue(item.pmTicketDetailId, value),
        );

      case 'Image':
        final bytes = provider.imageValueFor(item.pmTicketDetailId);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.greyBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (bytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(bytes,
                          width: 80, height: 80, fit: BoxFit.cover),
                    )
                  else
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.greyBorder.withOpacity(0.5)),
                      ),
                      child: const Icon(Icons.add_a_photo_outlined,
                          color: Colors.grey, size: 30),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPickImage,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label:
                          Text(bytes == null ? 'Take Photo' : 'Change Photo'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'Date':
        return TextFormField(
          controller: controllerFor(item.pmTicketDetailId,
              provider.textValueFor(item.pmTicketDetailId)),
          readOnly: true,
          decoration: decoration.copyWith(
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          onTap: onPickDate,
        );

      case 'TextBox':
      default:
        return TextFormField(
          controller: controllerFor(item.pmTicketDetailId,
              provider.textValueFor(item.pmTicketDetailId)),
          decoration: decoration,
          onChanged: (value) =>
              provider.updateTextValue(item.pmTicketDetailId, value),
        );
    }
  }
}
