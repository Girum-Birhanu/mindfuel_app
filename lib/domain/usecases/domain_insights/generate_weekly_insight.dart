// lib/domain/usecases/domain_insights/generate_weekly_insight.dart
import '../../entities/insight_entity.dart';
import '../../repositories/r_i_insight_repository.dart';

class GenerateWeeklyInsight {
  final RIInsightRepository repository;

  GenerateWeeklyInsight(this.repository);

  Future<InsightEntity> call(DateTime date) {
    return repository.generateWeeklyInsight(date);
  }
}
