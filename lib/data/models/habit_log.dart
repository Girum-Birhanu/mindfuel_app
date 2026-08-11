// lib/data/models/habit_log.dart
import 'package:hive/hive.dart';
import '../../domain/entities/habit_entity.dart';

part 'habit_log.g.dart';

@HiveType(typeId: 0)
class HabitLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double sleepHours;

  @HiveField(3)
  final String sleepQuality;

  @HiveField(4)
  final int caffeineCups;

  @HiveField(5)
  final String exerciseType;

  @HiveField(6)
  final int exerciseMinutes;

  @HiveField(7)
  final int stressLevel;

  @HiveField(8)
  final String workContext;

  @HiveField(9)
  final double capacityAtTime;

  HabitLog({
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

  factory HabitLog.fromEntity(HabitEntity entity) {
    return HabitLog(
      id: entity.id,
      timestamp: entity.timestamp,
      sleepHours: entity.sleepHours,
      sleepQuality: entity.sleepQuality,
      caffeineCups: entity.caffeineCups,
      exerciseType: entity.exerciseType,
      exerciseMinutes: entity.exerciseMinutes,
      stressLevel: entity.stressLevel,
      workContext: entity.workContext,
      capacityAtTime: entity.capacityAtTime,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      timestamp: timestamp,
      sleepHours: sleepHours,
      sleepQuality: sleepQuality,
      caffeineCups: caffeineCups,
      exerciseType: exerciseType,
      exerciseMinutes: exerciseMinutes,
      stressLevel: stressLevel,
      workContext: workContext,
      capacityAtTime: capacityAtTime,
    );
  }
}
