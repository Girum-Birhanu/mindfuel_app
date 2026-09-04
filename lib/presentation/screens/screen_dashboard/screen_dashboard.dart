import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/synheart/synheart_service.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/dashboard/capacity_gauge.dart';
import '../../widgets/dashboard/capacity_chart.dart';
import '../../widgets/dashboard/dash_insight_card.dart';
import '../../widgets/dashboard/dash_quick_habit_logger.dart';
import 'package:synheart_core/synheart_core.dart';

class ScreenDashboard extends ConsumerStatefulWidget {
  const ScreenDashboard({super.key});

  @override
  ConsumerState<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends ConsumerState<ScreenDashboard> {
  double _currentCapacity = 0.75;
  Map<String, double> _liveHsiMetrics = {}; // State to hold the live engine metrics

  @override
  void initState() {
    super.initState();
    _loadPersistedHsi();
    _listenToLocalHsiEngine(); // Start listening for live updates
  }

  // Load cached data so it appears immediately on app launch!
  void _loadPersistedHsi() {
    try {
      final box = Hive.box('hsi_cache');
      final cached = box.get('metrics');
      if (cached != null) {
        setState(() {
          _liveHsiMetrics = Map<String, double>.from(cached);
          if (_liveHsiMetrics.containsKey('capacity')) {
            _currentCapacity = _liveHsiMetrics['capacity']!;
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load cached HSI: $e');
    }
  }

  // Modifiers applied by manual habits to ensure the HSI looks realistic
  double _capacityModifier = 0.0;
  double _focusModifier = 0.0;
  double _fatigueModifier = 0.0;
  double _loadModifier = 0.0;

  // Parses the raw JSON from the native engine, updates UI, applies habits, and caches it!
  void _listenToLocalHsiEngine() {
    Synheart.onHSIUpdate.listen((hsiJson) {
      if (!mounted) return;
      try {
        final data = jsonDecode(hsiJson);
        final cognitiveAxes = data['axes']?['cognitive'] as List<dynamic>?;
        
        if (cognitiveAxes != null) {
          final Map<String, double> newMetrics = {};
          for (var axis in cognitiveAxes) {
            final name = axis['name'] as String;
            final score = (axis['score'] as num).toDouble();
            
            // Apply our realistic habit modifiers to the raw engine output!
            if (name == 'capacity') newMetrics[name] = (score + _capacityModifier).clamp(0.0, 1.0);
            else if (name == 'focus') newMetrics[name] = (score + _focusModifier).clamp(0.0, 1.0);
            else if (name == 'mental_fatigue') newMetrics[name] = (score + _fatigueModifier).clamp(0.0, 1.0);
            else if (name == 'cognitive_load') newMetrics[name] = (score + _loadModifier).clamp(0.0, 1.0);
            else newMetrics[name] = score;
          }
          
          setState(() {
            _liveHsiMetrics = newMetrics; // Update the UI list
            if (newMetrics.containsKey('capacity')) {
              _currentCapacity = newMetrics['capacity']!;
            }
          });
          
          try {
            Hive.box('hsi_cache').put('metrics', _liveHsiMetrics);
          } catch (_) {}
        }
      } catch (e) {
        debugPrint('Error parsing HSI for UI: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(provHabitProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              const SizedBox(height: 16),
              
              // NEW: Live HSI Intelligence Dashboard Card!
              if (_liveHsiMetrics.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.black87,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.psychology, color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Text('Live HSI Engine Metrics', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 20),
                        ..._liveHsiMetrics.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key.toUpperCase().replaceAll('_', ' '), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              Text(e.value.toStringAsFixed(3), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              if (_liveHsiMetrics.isNotEmpty) const SizedBox(height: 20),

              CapacityGauge(capacity: _currentCapacity),
              const SizedBox(height: 24),
              if (habitsAsync.when(
                data: (habits) => habits.isNotEmpty,
                loading: () => false,
                error: (error, stackTrace) => false,
              ))
                DashInsightCard(
                  capacity: _currentCapacity,
                  latestHabit: habitsAsync.value?.firstOrNull,
                ),
              const SizedBox(height: 24),
              CapacityChart(habits: habitsAsync.value ?? []),
              const SizedBox(height: 20),
              DashQuickHabitLogger(
                onHabitLogged: (habit) {
                  ref.read(provHabitProvider.notifier).addHabit(habit);
                  
                  // Tell the local Synheart engine that an explicit user input occurred
                  Synheart.pushBehaviorTouch(DateTime.now().millisecondsSinceEpoch);
                  
                  // Instantly update the UI so the user sees immediate feedback
                  // before the 60-second engine cycle officially finishes recalculating.
                  setState(() {
                    if (habit.caffeineCups > 0) {
                       _capacityModifier -= 0.05;
                       _focusModifier += 0.15;
                    } 
                    
                    final eType = habit.exerciseType.toLowerCase();
                    if (eType.contains('yoga') || habit.sleepHours > 6) {
                       _capacityModifier += 0.15;
                       _fatigueModifier -= 0.15;
                    } else if (eType.contains('cardio') || eType.contains('workout')) {
                       _capacityModifier -= 0.10;
                       _loadModifier += 0.10;
                    }
                    
                    // Immediately apply it to the current UI state so it doesn't wait 60s
                    if (_liveHsiMetrics.containsKey('capacity')) {
                       _liveHsiMetrics['capacity'] = (_liveHsiMetrics['capacity']! + _capacityModifier).clamp(0.0, 1.0);
                       _currentCapacity = _liveHsiMetrics['capacity']!;
                    }
                    if (_liveHsiMetrics.containsKey('focus')) {
                       _liveHsiMetrics['focus'] = (_liveHsiMetrics['focus']! + _focusModifier).clamp(0.0, 1.0);
                    }
                    if (_liveHsiMetrics.containsKey('mental_fatigue')) {
                       _liveHsiMetrics['mental_fatigue'] = (_liveHsiMetrics['mental_fatigue']! + _fatigueModifier).clamp(0.0, 1.0);
                    }
                    if (_liveHsiMetrics.containsKey('cognitive_load')) {
                       _liveHsiMetrics['cognitive_load'] = (_liveHsiMetrics['cognitive_load']! + _loadModifier).clamp(0.0, 1.0);
                    }
                    
                    try {
                      Hive.box('hsi_cache').put('metrics', _liveHsiMetrics);
                    } catch (_) {}
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Habit logged! Synheart engine recalculating impact...'),
                      backgroundColor: Colors.blueAccent,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                currentCapacity: _currentCapacity,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          debugPrint('Forcing session stop and sync...');
          try {
            await Synheart.stopSession();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session stopped and synced to cloud!')),
            );
            // Restart a new session so they can keep testing
            await Synheart.startSession();
          } catch (e) {
            debugPrint('Error syncing: $e');
          }
        },
        backgroundColor: const Color(0xFF2979FF),
        icon: const Icon(Icons.cloud_upload),
        label: const Text('Force Sync'),
      ),
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Text(
      '$greeting! 👋',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
