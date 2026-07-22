class AssetTypeOption {
  final int id;
  final String name;

  const AssetTypeOption(this.id, this.name);
}

class SiteOption {
  final int id;
  final String name;

  const SiteOption(this.id, this.name);
}

class AssetConstants {
  static const List<AssetTypeOption> assetTypes = [
    AssetTypeOption(1, 'Laptop'),
    AssetTypeOption(2, 'Monitor'),
    AssetTypeOption(3, 'Computer'),
    AssetTypeOption(4, 'Chair'),
    AssetTypeOption(5, 'Vaccum'),
    AssetTypeOption(6, 'Conference Room Table'),
    AssetTypeOption(7, 'Latex Exam Gloves'),
    AssetTypeOption(8, 'Mask'),
    AssetTypeOption(9, 'Truck'),
    AssetTypeOption(10, 'Desk'),
    AssetTypeOption(11, 'Computer Server'),
  ];

  static const List<SiteOption> sites = [
    SiteOption(4, 'NFC Solutions India'),
    SiteOption(5, 'NFC Solutions USA'),
  ];
}
