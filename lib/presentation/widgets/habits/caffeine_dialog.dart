// lib/presentation/widgets/habits/caffeine_dialog.dart
import 'package:flutter/material.dart';

class CaffeineDialog extends StatefulWidget {
  final void Function(int cups) onSave;

  const CaffeineDialog({super.key, required this.onSave});

  @override
  State<CaffeineDialog> createState() => _CaffeineDialogState();
}

class _CaffeineDialogState extends State<CaffeineDialog> {
  int _cups = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Caffeine'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Cups: $_cups'),
          Slider(
            value: _cups.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (val) => setState(() => _cups = val.toInt()),
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
            widget.onSave(_cups);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
