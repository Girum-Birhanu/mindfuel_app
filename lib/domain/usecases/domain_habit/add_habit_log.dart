// lib/domain/usecases/domain_habit/add_habit_log.dart
import '../../entities/habit_entity.dart';
import '../../repositories/r_i_habit_repository.dart';

class AddHabitLog {
  final RIHabitRepository repository;

  AddHabitLog(this.repository);

  Future<void> call(HabitEntity habit) {
    return repository.addHabitLog(habit);
  }
}
