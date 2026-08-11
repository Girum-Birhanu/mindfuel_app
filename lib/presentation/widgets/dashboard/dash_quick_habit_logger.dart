// lib/presentation/widgets/dashboard/dash_quick_habit_logger.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/habit_entity.dart';
import '../habits/sleep_dialog.dart';
import '../habits/caffeine_dialog.dart';
import '../habits/exercise_dialog.dart';

class DashQuickHabitLogger extends StatelessWidget {
  final Function(HabitEntity) onHabitLogged;
  final double currentCapacity;
  
  const DashQuickHabitLogger({
    super.key,
    required this.onHabitLogged,
    required this.currentCapacity,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Log', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHabitChip('😴 Sleep', Icons.bedtime, () {
                  showDialog(
                    context: context,
                    builder: (context) => SleepDialog(
                      onSave: (sleepHours, sleepQuality) {
                        final habit = HabitEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          timestamp: DateTime.now(),
                          sleepHours: sleepHours,
                          sleepQuality: sleepQuality,
                          caffeineCups: 0,
                          exerciseType: 'none',
                          exerciseMinutes: 0,
                          stressLevel: 5,
                          workContext: 'general',
                          capacityAtTime: currentCapacity,
                        );
                        onHabitLogged(habit);
                      },
                    ),
                  );
                }),
                _buildHabitChip('☕ Caffeine', Icons.coffee, () {
                  showDialog(
                    context: context,
                    builder: (context) => CaffeineDialog(
                      onSave: (caffeineCups) {
                        final habit = HabitEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          timestamp: DateTime.now(),
                          sleepHours: 0,
                          sleepQuality: 'okay',
                          caffeineCups: caffeineCups,
                          exerciseType: 'none',
                          exerciseMinutes: 0,
                          stressLevel: 5,
                          workContext: 'general',
                          capacityAtTime: currentCapacity,
                        );
                        onHabitLogged(habit);
                      },
                    ),
                  );
                }),
                _buildHabitChip('🏃 Exercise', Icons.directions_run, () {
                  showDialog(
                    context: context,
                    builder: (context) => ExerciseDialog(
                      onSave: (exerciseType, exerciseMinutes) {
                        final habit = HabitEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          timestamp: DateTime.now(),
                          sleepHours: 0,
                          sleepQuality: 'okay',
                          caffeineCups: 0,
                          exerciseType: exerciseType,
                          exerciseMinutes: exerciseMinutes,
                          stressLevel: 5,
                          workContext: 'general',
                          capacityAtTime: currentCapacity,
                        );
                        onHabitLogged(habit);
                      },
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHabitChip(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}