import 'dart:async';
import 'package:synheart_core/synheart_core.dart';

class SynheartService {
  // Singleton pattern
  static final SynheartService _instance = SynheartService._internal();

  factory SynheartService() {
    return _instance;
  }

  StreamSubscription? _subscription;
  final _capacityController = StreamController<double>.broadcast();

  SynheartService._internal() {
    // Listen to real SDK updates instead of mocking
    _subscription = Synheart.onStateUpdate.listen((state) {
      final cap = state.hsi.capacity?.value;
      if (cap != null) {
        _capacityController.add(cap);
      }
    });
  }

  Stream<double> get capacityStream => _capacityController.stream;

  void dispose() {
    _subscription?.cancel();
    _capacityController.close();
  }
}
