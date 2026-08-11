// lib/domain/usecases/domain_insights/generate_correlations.dart
import '../../entities/insight_entity.dart';
import '../../entities/habit_entity.dart';
import '../../repositories/r_i_insight_repository.dart';

class GenerateCorrelations {
  final RIInsightRepository repository;

  GenerateCorrelations(this.repository);

  Future<List<CorrelationEntity>> call(List<HabitEntity> habits) {
    return repository.generateCorrelations(habits);
  }
}
