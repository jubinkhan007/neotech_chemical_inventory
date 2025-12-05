import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.init(AppFlavor.production);
  runApp(const ProviderScope(child: ChemicalInventoryApp()));
}

class _ChemicalCard extends StatelessWidget {
  const _ChemicalCard({required this.chemical});

  final Chemical chemical;

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = Theme.of(context).cardTheme.color;
    final statusColor = chemical.isLowStock
        ? colorScheme.tertiary
        : colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfaceColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: kElevationToShadow[1],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Semantics(
              image: true,
              label: '${chemical.name} container icon',
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.science_outlined,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chemical.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${chemical.location} • Hazard: ${chemical.hazard}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: chemical.stockLevel,
                    semanticsLabel: '${chemical.name} fill level',
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _StatusChip(
                        label: '${(chemical.stockLevel * 100).round()}% full',
                        icon: Icons.local_shipping_outlined,
                      ),
                      _StatusChip(
                        label: 'Temp: ${chemical.temperature}°C',
                        icon: Icons.thermostat,
                      ),
                      _StatusChip(
                        label: 'Ventilation: ${chemical.ventilation}',
                        icon: Icons.air_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    chemical.isLowStock ? 'Low stock' : 'Stable',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'View details',
                      icon: const Icon(Icons.visibility_outlined),
                      onPressed: () {},
                      semanticLabel: 'View ${chemical.name} details',
                    ),
                    IconButton(
                      tooltip: 'Restock',
                      icon: const Icon(Icons.add_box_outlined),
                      onPressed: () {},
                      semanticLabel: 'Restock ${chemical.name}',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 18, semanticLabel: label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.chemical});

  final Chemical chemical;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      leading: Semantics(
        image: true,
        label: '${chemical.name} alert icon',
        child: CircleAvatar(
          backgroundColor: colorScheme.error.withOpacity(0.15),
          child: Icon(
            Icons.error_outline,
            color: colorScheme.error,
          ),
        ),
      ),
      title: Text(
        '${chemical.name} is low in storage',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        'Only ${(chemical.stockLevel * 100).round()}% remains. Confirm supplier ETA and move to ventilated shelf.',
      ),
      trailing: Semantics(
        button: true,
        label: 'Acknowledge alert for ${chemical.name}',
        child: TextButton(
          onPressed: () {},
          child: const Text('Acknowledge'),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isError
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Semantics(
            image: true,
            label: '$title illustration',
            child: Icon(
              icon,
              size: 56,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.valueKey,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Key valueKey;

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

class Chemical {
  const Chemical({
    required this.name,
    required this.location,
    required this.hazard,
    required this.stockLevel,
    required this.temperature,
    required this.ventilation,
    this.hasAlert = false,
  });

  final String name;
  final String location;
  final String hazard;
  final double stockLevel; // 0.0 - 1.0
  final double temperature;
  final String ventilation;
  final bool hasAlert;

  bool get isLowStock => stockLevel < 0.35;
}

const _sampleChemicals = [
  Chemical(
    name: 'Acetone',
    location: 'Cabinet A3',
    hazard: 'Flammable',
    stockLevel: 0.28,
    temperature: 22,
    ventilation: 'Required',
    hasAlert: true,
  ),
  Chemical(
    name: 'Hydrochloric Acid',
    location: 'Cabinet B1',
    hazard: 'Corrosive',
    stockLevel: 0.62,
    temperature: 20,
    ventilation: 'Required',
  ),
  Chemical(
    name: 'Sodium Hydroxide',
    location: 'Cabinet C2',
    hazard: 'Caustic',
    stockLevel: 0.44,
    temperature: 21,
    ventilation: 'Recommended',
  ),
  Chemical(
    name: 'Ethanol',
    location: 'Cold Storage',
    hazard: 'Flammable',
    stockLevel: 0.82,
    temperature: 4,
    ventilation: 'Recommended',
  ),
  Chemical(
    name: 'Ammonia Solution',
    location: 'Ventilated Shelf',
    hazard: 'Toxic',
    stockLevel: 0.31,
    temperature: 19,
    ventilation: 'Required',
    hasAlert: true,
  ),
];
