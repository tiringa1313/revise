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
  bool _isCameraActive = true; // Variável para controlar a ativação da câmera

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
    if (_controller == null || _isDetecting) return;
    _isDetecting = true;

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final textDetector = GoogleMlKit.vision.textDetector();
      final RecognisedText recognisedText =
          await textDetector.processImage(inputImage);

      setState(() {
        _scannedText = recognisedText.text;
        _isCameraActive =
            false; // Desativar a câmera após o escaneamento do texto
      });

      textDetector.close();
    } catch (e) {
      print(e);
    } finally {
      _isDetecting = false;
    }
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
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),
          Positioned(
            top: 16,
            left: 16,
            child: _scannedText != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Texto Escaneado: $_scannedText',
                      textAlign: TextAlign.left,
                    ),
                  )
                : SizedBox(),
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
