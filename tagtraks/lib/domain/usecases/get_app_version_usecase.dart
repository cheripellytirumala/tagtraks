import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/app_version_entity.dart';
import '../repositories/app_repository.dart';

class GetAppVersionUseCase {
  final AppRepository repository;

  GetAppVersionUseCase(this.repository);

  Future<Either<Failure, AppVersionEntity>> call({
    required int roleId,
    required String device,
    required String versionNumber,
  }) async {
    return await repository.getAppVersion(
      roleId: roleId,
      device: device,
      versionNumber: versionNumber,
    );
  }
}
