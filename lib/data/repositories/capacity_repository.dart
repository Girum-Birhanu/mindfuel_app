// lib/data/repositories/capacity_repository.dart
import 'dart:async';
import '../../domain/repositories/r_i_capacity_repository.dart';

class CapacityRepository implements RICapacityRepository {
  final _capacityController = StreamController<double>.broadcast();
  double _currentCapacity = 1.0;

  CapacityRepository() {
    _capacityController.add(_currentCapacity);
  }

  @override
  Stream<double> getCapacityStream() {
    return _capacityController.stream;
  }

  @override
  Future<double> getCurrentCapacity() async {
    return _currentCapacity;
  }

  @override
  Future<void> startTracking(String context) async {
    // In a real implementation, this might start a background timer
    // For now, it's just a mock
  }

  @override
  Future<void> stopTracking() async {
    // In a real implementation, this would stop the timer
  }

  void updateCapacity(double newCapacity) {
    _currentCapacity = newCapacity;
    _capacityController.add(_currentCapacity);
  }

  void dispose() {
    _capacityController.close();
  }
}
