import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
    String contactNumber,
    String password, {
    bool rememberMe = false,
  });
  Future<Either<Failure, String>> forgotPassword(String contactNumber);
}
