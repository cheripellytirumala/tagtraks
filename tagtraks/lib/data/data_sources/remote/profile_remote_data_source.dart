import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(int userAccountId);

  Future<ProfileModel> updateProfile({
    required int userAccountId,
    required String userName,
    required String email,
    required String contact,
    String? profileImageBase64,
  });

  Future<void> changePassword({
    required int userAccountId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSourceImpl(this.client);

  static final _userNamePattern = RegExp(r'id="UserName"[^>]*value="([^"]*)"');
  static final _userEmailPattern = RegExp(r'id="UserEmail"[^>]*value="([^"]*)"');
  static final _contactPattern = RegExp(r'id="Contact"[^>]*value="([^"]*)"');
  static final _profileImagePattern = RegExp(r'<img src="([^"]*)"\s+id="imgprvw"');
  static final _dangerAlertPattern = RegExp(
    r'alert-danger[\s\S]*?<strong>([^<]*)</strong>',
  );

  @override
  Future<ProfileModel> getProfile(int userAccountId) async {
    final html = await _fetchProfileHtml(userAccountId);
    return _parseProfile(html, userAccountId);
  }

  @override
  Future<ProfileModel> updateProfile({
    required int userAccountId,
    required String userName,
    required String email,
    required String contact,
    String? profileImageBase64,
  }) async {
    await client.post(
      ApiConstants.viewProfile,
      data: {
        ApiConstants.userAccountIdField: userAccountId.toString(),
        ApiConstants.profileImageField: profileImageBase64 ?? '',
        ApiConstants.userNameField: userName,
        ApiConstants.userEmailField: email,
        ApiConstants.contactField: contact,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final html = await _fetchProfileHtml(userAccountId);
    _throwIfError(html);
    return _parseProfile(html, userAccountId);
  }

  @override
  Future<void> changePassword({
    required int userAccountId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await client.post(
      ApiConstants.changePassword,
      data: {
        ApiConstants.userAccountIdField: userAccountId.toString(),
        ApiConstants.currentPasswordField: currentPassword,
        ApiConstants.newPasswordField: newPassword,
        ApiConstants.confirmPasswordField: confirmPassword,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final html = await _fetchProfileHtml(userAccountId);
    _throwIfError(html);
  }

  Future<String> _fetchProfileHtml(int userAccountId) async {
    final response = await client.get(
      '${ApiConstants.viewProfile}/$userAccountId',
      options: Options(responseType: ResponseType.plain),
    );
    return response.data as String;
  }

  void _throwIfError(String html) {
    final message = _dangerAlertPattern.firstMatch(html)?.group(1)?.trim();
    if (message != null && message.isNotEmpty) {
      throw ServerException(message);
    }
  }

  ProfileModel _parseProfile(String html, int userAccountId) {
    String valueOf(RegExp pattern) =>
        pattern.firstMatch(html)?.group(1)?.trim() ?? '';

    return ProfileModel(
      userAccountId: userAccountId,
      userName: valueOf(_userNamePattern),
      email: valueOf(_userEmailPattern),
      contact: valueOf(_contactPattern),
      profileImageUrl: _absoluteUrl(valueOf(_profileImagePattern)),
    );
  }

  String _absoluteUrl(String path) {
    if (path.isEmpty || path.startsWith('http')) return path;
    return ApiConstants.baseUrl + (path.startsWith('/') ? path.substring(1) : path);
  }
}
