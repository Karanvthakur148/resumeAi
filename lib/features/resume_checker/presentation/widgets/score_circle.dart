import 'package:flutter/material.dart';

class ScoreCircle extends StatelessWidget {
  final String label;
  final int score;
  const ScoreCircle({super.key, required this.label, required this.score});

  Color get _color {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  color: _color,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              Text('$score',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
