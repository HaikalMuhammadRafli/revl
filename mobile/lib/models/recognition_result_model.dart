class RecognitionResult {
  final bool success;
  final String? predictedPerson;
  final double confidence;
  final List<int>? bbox;

  RecognitionResult({
    required this.success,
    this.predictedPerson,
    this.confidence = 0.0,
    this.bbox,
  });

  factory RecognitionResult.fromJson(Map<String, dynamic> json) {
    return RecognitionResult(
      success: json['success'] ?? false,
      predictedPerson: json['predicted_person'],
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      bbox: json['bbox'] != null ? List<int>.from(json['bbox']) : null,
    );
  }

  factory RecognitionResult.error() {
    return RecognitionResult(success: false);
  }
}
