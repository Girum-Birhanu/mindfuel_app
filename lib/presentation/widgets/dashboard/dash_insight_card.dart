// lib/presentation/widgets/dashboard/dash_insight_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/habit_entity.dart';

class DashInsightCard extends StatelessWidget {
  final double capacity;
  final HabitEntity? latestHabit;
  
  const DashInsightCard({
    super.key,
    required this.capacity,
    this.latestHabit,
  });
  
  @override
  Widget build(BuildContext context) {
    String insight = 'Log your habits to receive personalized insights!';
    IconData icon = Icons.lightbulb_outline;
    
    if (latestHabit != null) {
      if (latestHabit!.sleepHours >= 7 && latestHabit!.sleepQuality == 'great') {
        insight = '💪 Great sleep last night! Your capacity is ${(capacity * 100).toInt()}% today.';
      } else if (latestHabit!.caffeineCups > 3) {
        insight = '☕ High caffeine intake may affect sleep quality. Consider reducing after 2PM.';
      } else if (latestHabit!.exerciseType != 'none' && latestHabit!.exerciseMinutes > 20) {
        insight = '🏃 Exercise boosts capacity! You\'re ${(capacity * 100).toInt()}% today.';
      }
    }
    
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(insight)),
          ],
        ),
      ),
    );
  }
}
