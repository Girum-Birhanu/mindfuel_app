// lib/domain/usecases/domain_habit/get_habit_logs.dart
import '../../entities/habit_entity.dart';
import '../../repositories/r_i_habit_repository.dart';

class GetHabitLogs {
  final RIHabitRepository repository;

  GetHabitLogs(this.repository);

  Future<List<HabitEntity>> call() {
    return repository.getHabitLogs();
  }
}
