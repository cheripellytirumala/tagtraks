import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/dashboard_summary_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummaryUseCase {
  final DashboardRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<Either<Failure, DashboardSummaryEntity>> call() {
    return repository.getDashboardSummary();
  }
}
