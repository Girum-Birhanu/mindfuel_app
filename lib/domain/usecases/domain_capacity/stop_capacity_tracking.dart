// lib/domain/usecases/domain_capacity/stop_capacity_tracking.dart
import '../../repositories/r_i_capacity_repository.dart';

class StopCapacityTracking {
  final RICapacityRepository repository;

  StopCapacityTracking(this.repository);

  Future<void> call() {
    return repository.stopTracking();
  }
}
