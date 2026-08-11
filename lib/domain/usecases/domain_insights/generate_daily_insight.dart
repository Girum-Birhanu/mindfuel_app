// lib/domain/usecases/domain_insights/generate_daily_insight.dart
import '../../entities/insight_entity.dart';
import '../../repositories/r_i_insight_repository.dart';

class GenerateDailyInsight {
  final RIInsightRepository repository;

  GenerateDailyInsight(this.repository);

  Future<InsightEntity> call(DateTime date) {
    return repository.generateDailyInsight(date);
  }
}
