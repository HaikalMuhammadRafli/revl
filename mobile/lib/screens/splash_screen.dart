import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:revl_mobile/services/api_service.dart';
import 'package:revl_mobile/screens/recognition_screen.dart';


class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SplashScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Initializing...';
  double _progress = 0.0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Check backend availability
      setState(() {
        _status = 'Checking backend...';
        _progress = 0.3;
      });

      final isAvailable = await ApiService.checkHealth();

      if (!isAvailable) {
        // Backend is cold, need to warm up
        setState(() {
          _status = 'Warming up backend...\nThis may take 10-30 seconds';
          _progress = 0.5;
        });

        final warmedUp = await ApiService.warmup();

        if (!warmedUp) {
          throw Exception('Failed to warm up backend');
        }
      }

      // Step 2: Initialize camera
      setState(() {
        _status = 'Initializing camera...';
        _progress = 0.8;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Step 3: Done!
      setState(() {
        _status = 'Ready!';
        _progress = 1.0;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to main screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RecognitionScreen(cameras: widget.cameras),
          ),
        );
      }

    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _status = 'Error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.face,
                    size: 80,
                    color: Colors.blue[900],
                  ),
                ),

                const SizedBox(height: 48),

                // App Title
                const Text(
                  'Face Recognition',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'with Mask Support',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 64),

                // Progress Indicator
                if (!_hasError) ...[
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Error Message
                if (_hasError) ...[
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    _status,
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _progress = 0;
                      });
                      _initializeApp();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
