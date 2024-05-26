import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isDetecting = false;
  String? _scannedText;
  bool _isCameraActive = true;
  Offset? _startSelection;
  Offset? _endSelection;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _scanText() async {
    if (_controller == null ||
        _isDetecting ||
        _startSelection == null ||
        _endSelection == null) return;
    _isDetecting = true;

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final textDetector = GoogleMlKit.vision.textDetector();
      final RecognisedText recognisedText =
          await textDetector.processImage(inputImage);

      setState(() {
        _scannedText = recognisedText.text;
        _isCameraActive = false;
      });

      textDetector.close();
    } catch (e) {
      print(e);
    } finally {
      _isDetecting = false;
    }
  }

  void _handleSelectionChange(Offset start, Offset end) {
    setState(() {
      _startSelection = start;
      _endSelection = end;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Anotação'),
      ),
      body: Stack(
        children: [
          if (_controller != null &&
              _controller!.value.isInitialized &&
              _isCameraActive)
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  _startSelection = details.localPosition;
                  _endSelection = null; // Limpa a seleção anterior
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _endSelection = details.localPosition;
                });
              },
              onTapUp: (details) {
                setState(() {
                  _endSelection = details.localPosition;
                });
              },
              child: CameraPreview(_controller!),
            ),
          if (_startSelection != null && _endSelection != null)
            Positioned(
              left: _startSelection!.dx,
              top: _startSelection!.dy,
              width: _endSelection!.dx - _startSelection!.dx,
              height: _endSelection!.dy - _startSelection!.dy,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
            ),
          if (_scannedText != null)
            Positioned(
              top: 16,
              left: 16,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$_scannedText',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          if (_controller != null &&
              _controller!.value.isInitialized &&
              _isCameraActive)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _scanText,
                child: Text('Escanear Anotação'),
              ),
            ),
        ],
      ),
    );
  }
}
