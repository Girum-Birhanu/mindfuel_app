// lib/core/di/injection_container.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/capacity_repository.dart';
import '../../data/repositories/insight_repository.dart';
import '../../domain/usecases/domain_habit/add_habit_log.dart';
import '../../domain/usecases/domain_habit/get_habit_logs.dart';
import '../../domain/usecases/domain_capacity/get_current_capacity.dart';
import '../../domain/usecases/domain_insights/generate_daily_insight.dart';

final providerContainer = ProviderContainer();

// Repository Providers
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository();
});

final capacityRepositoryProvider = Provider<CapacityRepository>((ref) {
  return CapacityRepository();
});

final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  return InsightRepository();
});

// UseCase Providers
final addHabitLogUseCaseProvider = Provider<AddHabitLog>((ref) {
  return AddHabitLog(ref.read(habitRepositoryProvider));
});

final getHabitLogsUseCaseProvider = Provider<GetHabitLogs>((ref) {
  return GetHabitLogs(ref.read(habitRepositoryProvider));
});

final getCurrentCapacityUseCaseProvider = Provider<GetCurrentCapacity>((ref) {
  return GetCurrentCapacity(ref.read(capacityRepositoryProvider));
});

final generateDailyInsightUseCaseProvider = Provider<GenerateDailyInsight>((
  ref,
) {
  return GenerateDailyInsight(ref.read(insightRepositoryProvider));
});
