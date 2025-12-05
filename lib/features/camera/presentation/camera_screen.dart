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
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Capture photo'),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_image != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last capture:',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(_image!.path, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _image!.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              )
            else
              Text(
                'No photo captured yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
