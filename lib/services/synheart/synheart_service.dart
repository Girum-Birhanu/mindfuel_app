import 'dart:async';
import 'dart:math';
import 'package:synheart_core/synheart_core.dart';

class SynheartService {
  // Set to true to mock data for UI testing without a smartwatch
  static const bool isDemoMode = true;

  // Singleton pattern
  static final SynheartService _instance = SynheartService._internal();

  factory SynheartService() {
    return _instance;
  }

  StreamSubscription? _subscription;
  Timer? _demoTimer;
  final _capacityController = StreamController<double>.broadcast();

  // For smooth demo movement
  double _currentDemoCapacity = 0.75;
  final Random _random = Random();

  SynheartService._internal() {
    if (isDemoMode) {
      // Demo Mode: Generate smoothly fluctuating capacity every 3 seconds
      _demoTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        // Random walk between -5% and +5%
        double change = (_random.nextDouble() * 0.10) - 0.05;
        _currentDemoCapacity = (_currentDemoCapacity + change).clamp(0.40, 0.98);
        _capacityController.add(_currentDemoCapacity);
      });
    } else {
      // Production Mode: Listen to real SDK updates
      _subscription = Synheart.onStateUpdate.listen((state) {
        final cap = state.hsi.capacity?.value;
        if (cap != null) {
          _capacityController.add(cap);
        }
      });
    }
  }

  Stream<double> get capacityStream => _capacityController.stream;

  void dispose() {
    _subscription?.cancel();
    _demoTimer?.cancel();
    _capacityController.close();
  }
}
