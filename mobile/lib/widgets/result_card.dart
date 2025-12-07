import 'package:flutter/material.dart';
import 'package:revl_mobile/models/recognition_result_model.dart';

class ResultCard extends StatelessWidget {
  final RecognitionResult? result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[800]!.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Scanning...',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!result!.success) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No face detected',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            result!.predictedPerson ?? 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Confidence: ${(result!.confidence * 100).toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
