import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException("Connection timed out");
      case DioExceptionType.badResponse:
        throw ServerException(err.response?.statusMessage ?? "Server error");
      case DioExceptionType.cancel:
        throw ServerException("Request cancelled");
      default:
        throw NetworkException("Unexpected error occurred");
    }
  }
}
