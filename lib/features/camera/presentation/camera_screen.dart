import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickedImageState {
  const PickedImageState({
    this.path,
    this.fileName,
    this.timestamp,
    this.errorMessage,
    this.isProcessing = false,
  });

  final String? path;
  final String? fileName;
  final DateTime? timestamp;
  final String? errorMessage;
  final bool isProcessing;

  factory PickedImageState.initial() => const PickedImageState();

  PickedImageState copyWith({
    String? path,
    String? fileName,
    DateTime? timestamp,
    String? errorMessage,
    bool? isProcessing,
  }) {
    return PickedImageState(
      path: path ?? this.path,
      fileName: fileName ?? this.fileName,
      timestamp: timestamp ?? this.timestamp,
      errorMessage: errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<PickedImageState> _imageState =
      ValueNotifier(PickedImageState.initial());

  @override
  void dispose() {
    _imageState.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    _imageState.value = _imageState.value.copyWith(
      isProcessing: true,
      errorMessage: null,
    );

    final hasPermission = await _ensurePermissions();

    if (!hasPermission) {
      _imageState.value = _imageState.value.copyWith(
        isProcessing: false,
        errorMessage: 'Camera or photo permissions were denied.',
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null) {
        _imageState.value = _imageState.value.copyWith(
          isProcessing: false,
          errorMessage: 'Capture cancelled.',
        );
        return;
      }

      final now = DateTime.now();

      _imageState.value = PickedImageState(
        path: image.path,
        fileName: _extractFileName(image.path),
        timestamp: now,
        isProcessing: false,
      );
    } catch (error) {
      _imageState.value = _imageState.value.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to capture image: $error',
      );
    }
  }

  Future<bool> _ensurePermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    if (cameraStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    final cameraGranted = cameraStatus.isGranted || cameraStatus.isLimited;
    final photosGranted = photosStatus.isGranted || photosStatus.isLimited;

    final platformAllowance =
        Platform.isAndroid && photosStatus.isDenied && cameraGranted;

    return cameraGranted && (photosGranted || platformAllowance);
  }

  String _extractFileName(String path) {
    if (path.isEmpty) return 'Unknown file';
    return path.split(Platform.pathSeparator).last;
  }

  String _formatTimestamp(DateTime timestamp) {
    final local = timestamp.toLocal();
    final twoDigits = (int value) => value.toString().padLeft(2, '0');
    final date =
        '${local.year}-${twoDigits(local.month)}-${twoDigits(local.day)}';
    final time =
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}:${twoDigits(local.second)}';
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<PickedImageState>(
          valueListenable: _imageState,
          builder: (context, state, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: state.isProcessing ? null : _captureImage,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(state.isProcessing ? 'Capturing...' : 'Capture Image'),
                ),
                const SizedBox(height: 16),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (state.path != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'File: ${state.fileName ?? 'Unknown'}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        if (state.timestamp != null)
                          Text('Captured: ${_formatTimestamp(state.timestamp!)}'),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(state.path!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text('No image captured yet.'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
