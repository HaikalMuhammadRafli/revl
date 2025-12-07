import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revl_mobile/core/config.dart';
import 'package:revl_mobile/models/recognition_result_model.dart';
import 'package:revl_mobile/services/image_service.dart';

class ApiService {
  static final http.Client _client = http.Client();

  /// Check if backend is healthy
  static Future<bool> checkHealth() async {
    try {
      final response = await _client
          .get(Uri.parse('${Config.BASE_URL}/health'))
          .timeout(const Duration(seconds: Config.CONNECT_TIMEOUT));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Warm up the backend (for cold start)
  static Future<bool> warmup() async {
    try {
      final response = await _client
          .get(Uri.parse('${Config.BASE_URL}/warmup'))
          .timeout(const Duration(seconds: Config.RECEIVE_TIMEOUT));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'warm';
      }
      return false;
    } catch (e) {
      debugPrint('Warmup failed: $e');
      return false;
    }
  }

  /// Recognize face from image
  static Future<RecognitionResult> recognize(String imagePath) async {
    try {
      // Process image in background isolate
      // This handles resize + compression without blocking UI
      final compressedBytes = await ImageService.processImage(imagePath);

      if (compressedBytes.isEmpty) {
        return RecognitionResult.error();
      }

      // Send request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.BASE_URL}/recognize'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          compressedBytes,
          filename: 'frame.jpg',
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: Config.RECEIVE_TIMEOUT),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RecognitionResult.fromJson(data);
      }

      return RecognitionResult.error();
    } catch (e) {
      debugPrint('Recognition error: $e');
      return RecognitionResult.error();
    }
  }
}
