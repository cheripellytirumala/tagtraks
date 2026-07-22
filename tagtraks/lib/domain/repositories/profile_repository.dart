import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(int userAccountId);

  Future<Either<Failure, ProfileEntity>> updateProfile({
    required int userAccountId,
    required String userName,
    required String email,
    required String contact,
    String? profileImageBase64,
  });

  Future<Either<Failure, void>> changePassword({
    required int userAccountId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
