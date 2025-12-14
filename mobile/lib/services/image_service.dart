import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Service to handle heavy image processing in background isolates
class ImageService {
  /// Compress and resize image for upload
  /// Returns JPEG bytes
  static Future<List<int>> processImage(String path) async {
    return await compute(_processImageIsolate, path);
  }

  /// The heavy lifting function to run in isolate
  static List<int> _processImageIsolate(String path) {
    try {
      // 1. Read file
      final file = File(path);
      final bytes = file.readAsBytesSync();

      // 2. Decode image
      final image = img.decodeImage(bytes);
      if (image == null) return [];

      // 3. Resize (WhatsApp style: max 1280px or 1600px long edge)
      // We'll use 1280px as a safe balance for speed/quality
      final int maxDimension = 1280;

      img.Image resized = image;
      if (image.width > maxDimension || image.height > maxDimension) {
        if (image.width > image.height) {
          resized = img.copyResize(image, width: maxDimension);
        } else {
          resized = img.copyResize(image, height: maxDimension);
        }
      }

      // 4. Encode to JPG with 95% quality (minimal compression for consistency)
      return img.encodeJpg(resized, quality: 95);
    } catch (e) {
      debugPrint('Image processing error: $e');
      return [];
    }
  }
}
