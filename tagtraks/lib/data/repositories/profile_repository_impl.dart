import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/remote/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(int userAccountId) async {
    try {
      final model = await remoteDataSource.getProfile(userAccountId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required int userAccountId,
    required String userName,
    required String email,
    required String contact,
    String? profileImageBase64,
  }) async {
    try {
      final model = await remoteDataSource.updateProfile(
        userAccountId: userAccountId,
        userName: userName,
        email: email,
        contact: contact,
        profileImageBase64: profileImageBase64,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required int userAccountId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        userAccountId: userAccountId,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
