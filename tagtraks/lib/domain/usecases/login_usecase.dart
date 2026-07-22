import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String contactNumber,
    String password, {
    bool rememberMe = false,
  }) {
    return repository.login(contactNumber, password, rememberMe: rememberMe);
  }
}
