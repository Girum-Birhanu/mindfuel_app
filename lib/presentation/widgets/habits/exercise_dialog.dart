// lib/presentation/widgets/habits/exercise_dialog.dart
import 'package:flutter/material.dart';

class ExerciseDialog extends StatefulWidget {
  final void Function(String exerciseType, int minutes) onSave;

  const ExerciseDialog({super.key, required this.onSave});

  @override
  State<ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  String _type = 'cardio';
  int _minutes = 30;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _type,
            items: const [
              DropdownMenuItem(value: 'none', child: Text('None')),
              DropdownMenuItem(value: 'cardio', child: Text('Cardio')),
              DropdownMenuItem(value: 'strength', child: Text('Strength Training')),
              DropdownMenuItem(value: 'yoga', child: Text('Yoga/Stretching')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _type = val);
            },
          ),
          const SizedBox(height: 16),
          Text('Minutes: $_minutes'),
          Slider(
            value: _minutes.toDouble(),
            min: 0,
            max: 120,
            divisions: 12,
            onChanged: (val) => setState(() => _minutes = val.toInt()),
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
            widget.onSave(_type, _minutes);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
