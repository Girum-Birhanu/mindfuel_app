// lib/domain/usecases/domain_capacity/start_capacity_tracking.dart
import '../../repositories/r_i_capacity_repository.dart';

class StartCapacityTracking {
  final RICapacityRepository repository;

  StartCapacityTracking(this.repository);

  Future<void> call(String context) {
    return repository.startTracking(context);
  }
}
