import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:revl_mobile/models/recognition_result_model.dart';
import 'package:revl_mobile/services/api_service.dart';
import 'package:revl_mobile/widgets/result_card.dart';
import 'package:revl_mobile/widgets/stats_card.dart';
import 'package:revl_mobile/widgets/detection_overlay_painter.dart';

class RecognitionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const RecognitionScreen({super.key, required this.cameras});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  Timer? _captureTimer;

  bool _isProcessing = false;
  RecognitionResult? _lastResult;

  // Stats
  int _frameCount = 0;
  int _successCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App Lifecycle Management
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // App became inactive (minimized or phone locked)
      _stopCapture();
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // App came back to foreground
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    _cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,  // High resolution for better quality
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
        _startCapture();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _startCapture() {
    _captureTimer?.cancel(); // Ensure no duplicates
    // Capture every 300ms for faster detection
    _captureTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) => _captureAndRecognize(),
    );
  }

  void _stopCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
  }

  Future<void> _captureAndRecognize() async {
    if (_isProcessing || _cameraController == null) return;

    setState(() {
      _isProcessing = true;
      _frameCount++;
    });

    try {
      final image = await _cameraController!.takePicture();
      final result = await ApiService.recognize(image.path);

      if (mounted) {
        setState(() {
          _lastResult = result;

          if (result.success) _successCount++;
        });
      }
    } catch (e) {
      debugPrint('Recognition error: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCapture();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          Center(child: CameraPreview(_cameraController!)),

          // Detection Overlay (bounding boxes and eye ROI)
          if (_lastResult != null)
            Center(
              child: CustomPaint(
                painter: DetectionOverlayPainter(
                  result: _lastResult,
                  imageSize: _cameraController!.value.previewSize!,
                ),
                size: Size.infinite,
              ),
            ),

          // Recognition Result Overlay
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: ResultCard(result: _lastResult),
          ),

          // Stats
          Positioned(
            bottom: 20,
            left: 16,
            child: StatsCard(
              frameCount: _frameCount,
              successCount: _successCount,
            ),
          ),

          // Processing Indicator
          if (_isProcessing)
            Positioned(
              top: 50,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
