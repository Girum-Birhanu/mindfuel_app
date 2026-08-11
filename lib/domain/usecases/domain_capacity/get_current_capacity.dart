// lib/domain/usecases/domain_capacity/get_current_capacity.dart
import '../../repositories/r_i_capacity_repository.dart';

class GetCurrentCapacity {
  final RICapacityRepository repository;

  GetCurrentCapacity(this.repository);

  Future<double> call() {
    return repository.getCurrentCapacity();
  }
}
