// lib/domain/entities/habit_entity.dart

class HabitEntity {
  final String id;
  final DateTime timestamp;
  final double sleepHours;
  final String sleepQuality;
  final int caffeineCups;
  final String exerciseType;
  final int exerciseMinutes;
  final int stressLevel;
  final String workContext;
  final double capacityAtTime;

  HabitEntity({
    required this.id,
    required this.timestamp,
    required this.sleepHours,
    required this.sleepQuality,
    required this.caffeineCups,
    required this.exerciseType,
    required this.exerciseMinutes,
    required this.stressLevel,
    required this.workContext,
    required this.capacityAtTime,
  });
}
