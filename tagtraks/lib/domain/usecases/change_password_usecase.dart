import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int userAccountId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return repository.changePassword(
      userAccountId: userAccountId,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
