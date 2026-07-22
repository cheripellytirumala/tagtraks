class ApiConstants {
  static const String baseUrl = 'https://tagtraks.com/';
  static const String getAppVersion = 'getAppVersion';

  // Query Parameters
  static const String roleId = 'role_id';
  static const String device = 'device';
  static const String versionNumber = 'version_number';

  // Account/Login page (server-rendered MVC form, not a JSON API)
  static const String login = 'Account/Login';
  static const String forgotPassword = 'Account/ForgotPassword';

  // Login form field names
  static const String contactNumberField = 'ContactNumber';
  static const String passwordField = 'Password';
  static const String rememberMeField = 'rememberme';
  static const String verificationTokenField = '__RequestVerificationToken';

  // Account/Dashboard (server-rendered page with embedded JSON) + its JSON API
  static const String dashboard = 'Account/Dashboard';
  static const String siteAssets = 'Account/SiteAssets';
  static const String assetTypeIdField = 'assetTypeId';
  static const String siteIdField = 'SiteId';

  // Asset/AssetList + Asset/Create (server-rendered pages + their JSON APIs)
  static const String siteAssetsCount = 'Account/SiteAssetsCount';
  static const String assetCreate = 'Asset/Create';
  static const String assetNew = 'Asset/NewAsset';
  static const String assetDelete = 'Asset/DeleteAsset';
  static const String addAssetChecklist = 'Asset/GetAddAssetChecklist';

  // Asset/ImportExport (Bulk Upload) — server-rendered page + its JSON API.
  // NOTE: "ImportAssests" is misspelled on the real server; kept verbatim.
  static const String importExport = 'Asset/ImportExport';
  static const String importAssets = 'Asset/ImportAssests';
  static const String downloadTemplate = 'Asset/DownloadTemplate';

  // Account/Viewprofile — server-rendered page (GET) + its form posts.
  // GET is Account/Viewprofile/{id}; the "My Account" form posts to Account/ViewProfile
  // (capital P) — ASP.NET routing is case-insensitive so either casing resolves the same.
  static const String viewProfile = 'Account/Viewprofile';
  static const String changePassword = 'Account/ChangePassword';

  // View profile ("My Account") form field names
  static const String userAccountIdField = 'UserAccountId';
  static const String profileImageField = 'ProfileImage';
  static const String userNameField = 'UserName';
  static const String userEmailField = 'UserEmail';
  static const String contactField = 'Contact';

  // Change password form field names
  static const String currentPasswordField = 'CurrentPassword';
  static const String newPasswordField = 'NewPassword';
  static const String confirmPasswordField = 'ConfirmPassword';
}
