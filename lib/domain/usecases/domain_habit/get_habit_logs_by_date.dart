// lib/domain/usecases/domain_habit/get_habit_logs_by_date.dart
import '../../entities/habit_entity.dart';
import '../../repositories/r_i_habit_repository.dart';

class GetHabitLogsByDate {
  final RIHabitRepository repository;

  GetHabitLogsByDate(this.repository);

  Future<List<HabitEntity>> call(DateTime date) {
    return repository.getHabitLogsByDate(date);
  }
}
