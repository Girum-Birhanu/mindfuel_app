// lib/presentation/providers/prov_habit_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/usecases/domain_habit/add_habit_log.dart';
import '../../domain/usecases/domain_habit/get_habit_logs.dart';

class HabitProvider extends StateNotifier<AsyncValue<List<HabitEntity>>> {
  final AddHabitLog _addHabitLog;
  final GetHabitLogs _getHabitLogs;

  HabitProvider({required AddHabitLog addHabitLog, required GetHabitLogs getHabitLogs})
    : _addHabitLog = addHabitLog,
      _getHabitLogs = getHabitLogs,
      super(const AsyncValue.loading()) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    try {
      final habits = await _getHabitLogs();
      state = AsyncValue.data(habits);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> addHabit(HabitEntity habit) async {
    final previousState = state;
    try {
      final currentHabits = state.value ?? [];
      state = AsyncValue.data([habit, ...currentHabits]);
      await _addHabitLog(habit);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      if (previousState.hasValue) {
        state = previousState;
      }
    }
  }
}

final provHabitProvider =
    StateNotifierProvider<HabitProvider, AsyncValue<List<HabitEntity>>>((ref) {
      final addHabitLog = ref.read(addHabitLogUseCaseProvider);
      final getHabitLogs = ref.read(getHabitLogsUseCaseProvider);
      return HabitProvider(
        addHabitLog: addHabitLog,
        getHabitLogs: getHabitLogs,
      );
    });
