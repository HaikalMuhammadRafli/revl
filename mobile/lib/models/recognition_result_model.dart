class RecognitionResult {
  final bool success;
  final String? predictedPerson;
  final double confidence;
  final List<int>? bbox;
  final List<int>? eyeRoi;

  RecognitionResult({
    required this.success,
    this.predictedPerson,
    this.confidence = 0.0,
    this.bbox,
    this.eyeRoi,
  });

  factory RecognitionResult.fromJson(Map<String, dynamic> json) {
    return RecognitionResult(
      success: json['success'] ?? false,
      predictedPerson: json['predicted_person'],
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      bbox: json['bbox'] != null ? List<int>.from(json['bbox']) : null,
      eyeRoi: json['eye_roi'] != null ? List<int>.from(json['eye_roi']) : null,
    );
  }

  factory RecognitionResult.error() {
    return RecognitionResult(success: false);
  }
}
