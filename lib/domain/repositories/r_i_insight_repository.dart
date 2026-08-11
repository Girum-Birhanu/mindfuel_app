// lib/domain/repositories/r_i_insight_repository.dart
import 'package:mindfuel_app/domain/entities/habit_entity.dart';

import '../entities/insight_entity.dart';

abstract class RIInsightRepository {
  Future<InsightEntity> generateDailyInsight(DateTime date);
  Future<InsightEntity> generateWeeklyInsight(DateTime date);
  Future<List<CorrelationEntity>> generateCorrelations(
    List<HabitEntity> habits,
  );
}
