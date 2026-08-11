// lib/presentation/screens/screen_dashboard/screen_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/synheart/synheart_service.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/dashboard/capacity_gauge.dart';
import '../../widgets/dashboard/capacity_chart.dart';
import '../../widgets/dashboard/dash_insight_card.dart';
import '../../widgets/dashboard/dash_quick_habit_logger.dart';

class ScreenDashboard extends ConsumerStatefulWidget {
  const ScreenDashboard({super.key});

  @override
  ConsumerState<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends ConsumerState<ScreenDashboard> {
  double _currentCapacity = 0.75;

  @override
  void initState() {
    super.initState();
    _listenToCapacity();
  }

  void _listenToCapacity() {
    final service = SynheartService();
    service.capacityStream.listen((capacity) {
      if (mounted) {
        setState(() {
          _currentCapacity = capacity;
        });
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
              const SizedBox(height: 20),
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
                },
                currentCapacity: _currentCapacity,
              ),
            ],
          ),
        ),
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
