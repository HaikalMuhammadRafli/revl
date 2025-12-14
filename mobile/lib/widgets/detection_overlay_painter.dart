import 'package:flutter/material.dart';
import 'package:revl_mobile/models/recognition_result_model.dart';

class DetectionOverlayPainter extends CustomPainter {
  final RecognitionResult? result;
  final Size imageSize;

  DetectionOverlayPainter({
    required this.result,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (result == null || !result!.success) return;

    // Calculate scaling factors to map from image coordinates to display coordinates
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    // Draw face bounding box (green)
    if (result!.bbox != null && result!.bbox!.length == 4) {
      final bbox = result!.bbox!;
      final rect = Rect.fromLTRB(
        bbox[0] * scaleX,
        bbox[1] * scaleY,
        bbox[2] * scaleX,
        bbox[3] * scaleY,
      );

      final facePaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawRect(rect, facePaint);

      // Draw label with person name and confidence
      if (result!.predictedPerson != null) {
        final textSpan = TextSpan(
          text: '${result!.predictedPerson} (${(result!.confidence * 100).toStringAsFixed(1)}%)',
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.black54,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        
        // Position label above the bounding box
        final labelOffset = Offset(
          rect.left,
          rect.top - textPainter.height - 4,
        );

        textPainter.paint(canvas, labelOffset);
      }
    }

    // Draw eye ROI (blue)
    if (result!.eyeRoi != null && result!.eyeRoi!.length == 4) {
      final eyeRoi = result!.eyeRoi!;
      final rect = Rect.fromLTRB(
        eyeRoi[0] * scaleX,
        eyeRoi[1] * scaleY,
        eyeRoi[2] * scaleX,
        eyeRoi[3] * scaleY,
      );

      final eyePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawRect(rect, eyePaint);

      // Draw "Eye ROI" label
      const textSpan = TextSpan(
        text: 'Eye ROI',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black54,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      
      // Position label at top-left of eye ROI
      final labelOffset = Offset(
        rect.left,
        rect.top - textPainter.height - 2,
      );

      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(DetectionOverlayPainter oldDelegate) {
    return oldDelegate.result != result || oldDelegate.imageSize != imageSize;
  }
}
