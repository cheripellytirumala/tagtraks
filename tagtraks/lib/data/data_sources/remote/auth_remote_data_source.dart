import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String contactNumber, String password, {bool rememberMe = false});
  Future<({int statusCode, String statusMessage})> forgotPassword(String contactNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl(this.client);

  static final _tokenPattern = RegExp(
    r'name="__RequestVerificationToken"[^>]*value="([^"]+)"',
  );
  static final _validationErrorPattern = RegExp(
    r'validation-summary-errors[\s\S]*?<li>\s*([^<]+?)\s*</li>',
  );

  @override
  Future<UserModel> login(
    String contactNumber,
    String password, {
    bool rememberMe = false,
  }) async {
    final loginPage = await client.get(
      ApiConstants.login,
      options: Options(responseType: ResponseType.plain),
    );

    final tokenMatch = _tokenPattern.firstMatch(loginPage.data as String);
    if (tokenMatch == null) {
      throw ParsingException('Unable to read the login form. Please try again.');
    }

    final response = await client.post(
      ApiConstants.login,
      data: {
        ApiConstants.contactNumberField: contactNumber,
        ApiConstants.passwordField: password,
        ApiConstants.rememberMeField: rememberMe.toString(),
        ApiConstants.verificationTokenField: tokenMatch.group(1)!,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (response.statusCode == 302) {
      final location = response.headers.value('location') ?? '';
      if (location.toLowerCase().contains('/account/login')) {
        throw ServerException('Invalid login attempt');
      }
      return UserModel(token: '', name: contactNumber);
    }

    final errorMatch = _validationErrorPattern.firstMatch(response.data as String);
    throw ServerException(errorMatch?.group(1) ?? 'Invalid login attempt');
  }

  @override
  Future<({int statusCode, String statusMessage})> forgotPassword(
    String contactNumber,
  ) async {
    final response = await client.get(
      ApiConstants.forgotPassword,
      queryParameters: {ApiConstants.contactNumberField: contactNumber},
    );

    final data = response.data as Map<String, dynamic>;
    return (
      statusCode: data['statusCode'] as int? ?? 0,
      statusMessage: data['statusMessage'] as String? ??
          'Something went wrong. Please try again.',
    );
  }
}
