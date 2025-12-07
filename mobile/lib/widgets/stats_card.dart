import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int frameCount;
  final int successCount;

  const StatsCard({
    super.key,
    required this.frameCount,
    required this.successCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Frames: $frameCount',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
          Text(
            'Success: $successCount',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
