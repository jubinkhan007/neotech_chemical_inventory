import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TextRecognitionPage(),
    );
  }
}

class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({super.key});

  @override
  State<TextRecognitionPage> createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  CameraController? _cameraController;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _isInitializingCamera = false;
  bool _isProcessingText = false;
  String? _recognizedText;
  String? _errorMessage;

  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _requestPermissionAndInitialize() async {
    setState(() {
      _isInitializingCamera = true;
      _errorMessage = null;
    });

    final status = await Permission.camera.request();
    if (!mounted) return;

    setState(() => _permissionStatus = status);

    if (status.isGranted) {
      await _initializeCamera();
    } else {
      setState(() => _isInitializingCamera = false);
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializingCamera = true;
      _errorMessage = null;
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No camera available on this device.';
        });
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController?.dispose();
        _cameraController = controller;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isInitializingCamera = false);
      }
    }
  }

  Future<void> _captureAndRecognize() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized || _isProcessingText) {
      return;
    }

    setState(() {
      _isProcessingText = true;
      _errorMessage = null;
    });

    try {
      final file = await controller.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      setState(() {
        _recognizedText = recognizedText.text.isNotEmpty
            ? recognizedText.text
            : 'No text detected in the captured image.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to recognize text: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isProcessingText = false);
      }
    }
  }

  Widget _buildPermissionNotice() {
    final description = _permissionStatus.isPermanentlyDenied
        ? 'Camera permission is permanently denied. Please enable it in settings to scan text.'
        : 'Camera permission is required to capture photos for text recognition.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _permissionStatus.isPermanentlyDenied
              ? openAppSettings
              : _requestPermissionAndInitialize,
          child: Text(_permissionStatus.isPermanentlyDenied
              ? 'Open Settings'
              : 'Grant Permission'),
        ),
      ],
    );
  }

  Widget _buildCameraContent() {
    if (!_permissionStatus.isGranted) {
      return _buildPermissionNotice();
    }

    if (_isInitializingCamera) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorCard(_errorMessage!);
    }

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: Text('Camera is not ready yet.'));
    }

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
        if (_isProcessingText)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecognizedText() {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.article_outlined),
              const SizedBox(width: 8),
              Text('Extracted Text', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          if (_errorMessage != null)
            _buildErrorCard(_errorMessage!)
          else if (_recognizedText != null)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60, maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _recognizedText!,
                  style: textTheme.bodyLarge,
                ),
              ),
            )
          else
            Text(
              'Capture a photo to see recognized text here.',
              style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Recognition OCR'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Capture a photo to extract text using Google ML Kit.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black,
                    child: _buildCameraContent(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: (_cameraController?.value.isInitialized ?? false) &&
                            !_isProcessingText &&
                            _permissionStatus.isGranted
                        ? _captureAndRecognize
                        : null,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Capture & Recognize'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildRecognizedText(),
            ],
          ),
        ),
      ),
    );
  }
}
