// lib/services/synheart/synheart_service.dart
import 'dart:async';

class SynheartService {
  // Singleton pattern
  static final SynheartService _instance = SynheartService._internal();

  factory SynheartService() {
    return _instance;
  }

  SynheartService._internal() {
    // Start generating mock capacity values
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _capacityController.add(0.85); // Mock capacity
    });
  }

  final _capacityController = StreamController<double>.broadcast();

  Stream<double> get capacityStream => _capacityController.stream;

  void dispose() {
    _capacityController.close();
  }
}
