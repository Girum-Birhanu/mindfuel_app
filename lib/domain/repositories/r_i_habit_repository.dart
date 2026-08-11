// lib/domain/repositories/r_i_habit_repository.dart

import '../entities/habit_entity.dart';

abstract class RIHabitRepository {
  Future<void> addHabitLog(HabitEntity habit);
  Future<List<HabitEntity>> getHabitLogs();
  Future<List<HabitEntity>> getHabitLogsByDate(DateTime date);
  Future<void> deleteHabitLog(String id);
  Future<void> updateHabitLog(HabitEntity habit);
}
