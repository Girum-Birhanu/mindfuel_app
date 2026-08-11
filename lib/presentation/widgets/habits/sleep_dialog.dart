// lib/presentation/widgets/habits/sleep_dialog.dart
import 'package:flutter/material.dart';

class SleepDialog extends StatefulWidget {
  final void Function(double sleepHours, String sleepQuality) onSave;

  const SleepDialog({super.key, required this.onSave});

  @override
  State<SleepDialog> createState() => _SleepDialogState();
}

class _SleepDialogState extends State<SleepDialog> {
  double _hours = 7.0;
  String _quality = 'good';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Sleep'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Hours: ${_hours.toStringAsFixed(1)}'),
          Slider(
            value: _hours,
            min: 0,
            max: 12,
            divisions: 24,
            onChanged: (val) => setState(() => _hours = val),
          ),
          DropdownButton<String>(
            value: _quality,
            items: const [
              DropdownMenuItem(value: 'poor', child: Text('Poor')),
              DropdownMenuItem(value: 'okay', child: Text('Okay')),
              DropdownMenuItem(value: 'good', child: Text('Good')),
              DropdownMenuItem(value: 'great', child: Text('Great')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _quality = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_hours, _quality);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
