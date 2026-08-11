// lib/domain/entities/insight_entity.dart

class InsightEntity {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;

  InsightEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

class CorrelationEntity {
  final String metric1;
  final String metric2;
  final double correlationScore;
  final String interpretation;

  CorrelationEntity({
    required this.metric1,
    required this.metric2,
    required this.correlationScore,
    required this.interpretation,
  });
}
