import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call({
    required int userAccountId,
    required String userName,
    required String email,
    required String contact,
    String? profileImageBase64,
  }) {
    return repository.updateProfile(
      userAccountId: userAccountId,
      userName: userName,
      email: email,
      contact: contact,
      profileImageBase64: profileImageBase64,
    );
  }
}
