// lib/domain/repositories/r_i_capacity_repository.dart


abstract class RICapacityRepository {
  Stream<double> getCapacityStream();
  Future<double> getCurrentCapacity();
  Future<void> startTracking(String context);
  Future<void> stopTracking();
}
