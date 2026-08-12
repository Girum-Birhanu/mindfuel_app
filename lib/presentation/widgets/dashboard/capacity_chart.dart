// lib/presentation/widgets/dashboard/capacity_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/habit_entity.dart';

class CapacityChart extends StatelessWidget {
  final List<HabitEntity> habits;

  const CapacityChart({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('Not enough data for chart yet', style: TextStyle(color: Colors.white70))),
        ),
      );
    }

    final sortedHabits = List<HabitEntity>.from(habits)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final spots = sortedHabits.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.capacityAtTime * 100);
    }).toList();

    // Modern Gradient Colors
    final List<Color> gradientColors = [
      const Color(0xFF00E5FF), // Cyan
      const Color(0xFF2979FF), // Deep Blue
    ];

    return Card(
      elevation: 8,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF1E1E2C), // Sleek dark surface
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capacity Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false), // Removed grid lines for clarity
                  titlesData: const FlTitlesData(show: false), // Removed axes for a sleek, minimalist look
                  borderData: FlBorderData(show: false), // Clean borderless look
                  minX: 0,
                  maxX: (spots.length - 1).toDouble() > 0 ? (spots.length - 1).toDouble() : 1,
                  minY: 0,
                  maxY: 100,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => const Color(0xFF32324A),
                      tooltipRoundedRadius: 12,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toInt()}% Capacity',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: LinearGradient(colors: gradientColors),
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false), // Hide dots for smooth look
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors.map((color) => color.withOpacity(0.2)).toList(),
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
