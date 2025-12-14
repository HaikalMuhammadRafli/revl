import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int frameCount;
  final int successCount;
  final int captureTime;
  final int apiCallTime;
  final int totalTime;

  const StatsCard({
    super.key,
    required this.frameCount,
    required this.successCount,
    this.captureTime = 0,
    this.apiCallTime = 0,
    this.totalTime = 0,
  });

  @override
  Widget build(BuildContext context) {
    final successRate = frameCount > 0 ? (successCount / frameCount * 100) : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: totalTime < 500
              ? Colors.green
              : totalTime < 800
                  ? Colors.orange
                  : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.analytics, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Stats & Performance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Frame Stats
          _buildStatRow('Frames', '$frameCount', Colors.blue),
          _buildStatRow('Success', '$successCount (${successRate.toStringAsFixed(0)}%)', Colors.green),
          
          const Divider(color: Colors.grey, height: 12),
          
          // Performance Metrics
          _buildStatRow('Capture', '${captureTime}ms', Colors.cyan),
          _buildStatRow('API Call', '${apiCallTime}ms', Colors.purple),
          _buildStatRow(
            'Total',
            '${totalTime}ms',
            totalTime < 500
                ? Colors.green
                : totalTime < 800
                    ? Colors.orange
                    : Colors.red,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 11,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
