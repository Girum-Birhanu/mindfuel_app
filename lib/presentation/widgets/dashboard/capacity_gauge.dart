// lib/presentation/widgets/dashboard/capacity_gauge.dart
import 'package:flutter/material.dart';

class CapacityGauge extends StatelessWidget {
  final double capacity;

  const CapacityGauge({super.key, required this.capacity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Current Capacity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                value: capacity,
                strokeWidth: 12,
                backgroundColor: Colors.grey.shade200,
                color: _getColorForCapacity(capacity),
              ),
            ),
            Text(
              '${(capacity * 100).toInt()}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getColorForCapacity(double value) {
    if (value > 0.7) return Colors.green;
    if (value > 0.4) return Colors.orange;
    return Colors.red;
  }
}
