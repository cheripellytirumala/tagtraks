import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(
    String contactNumber,
    String password, {
    bool rememberMe = false,
  }) async {
    try {
      final user = await remoteDataSource.login(
        contactNumber,
        password,
        rememberMe: rememberMe,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Invalid login attempt'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String contactNumber) async {
    try {
      final result = await remoteDataSource.forgotPassword(contactNumber);
      if (result.statusCode == 1) {
        return Right(result.statusMessage);
      }
      return Left(ServerFailure(result.statusMessage));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } on NetworkException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
