// lib/data/repositories/habit_repository.dart
import 'package:hive/hive.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/r_i_habit_repository.dart';
import '../models/habit_log.dart';

class HabitRepository implements RIHabitRepository {
  final Box<HabitLog> _box;

  HabitRepository() : _box = Hive.box<HabitLog>('habit_logs');

  @override
  Future<void> addHabitLog(HabitEntity habit) async {
    final log = HabitLog.fromEntity(habit);
    await _box.put(log.id, log);
  }

  @override
  Future<List<HabitEntity>> getHabitLogs() async {
    return _box.values.map((log) => log.toEntity()).toList();
  }

  @override
  Future<List<HabitEntity>> getHabitLogsByDate(DateTime date) async {
    return _box.values
        .where((log) =>
            log.timestamp.year == date.year &&
            log.timestamp.month == date.month &&
            log.timestamp.day == date.day)
        .map((log) => log.toEntity())
        .toList();
  }

  @override
  Future<void> deleteHabitLog(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateHabitLog(HabitEntity habit) async {
    final log = HabitLog.fromEntity(habit);
    await _box.put(log.id, log);
  }
}
