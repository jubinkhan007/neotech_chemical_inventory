import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/ui/app_spacing.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  XFile? _capturedImage;
  DateTime? _captureTimestamp;
  String? _extractedText;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _captureImage() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final hasPermission = await _ensurePermissions();

    if (!hasPermission) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Camera or photo permissions were denied.';
      });
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image == null) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Capture cancelled.';
        });
        return;
      }

      setState(() {
        _capturedImage = image;
        _captureTimestamp = DateTime.now();
        _extractedText = null;
      });

      // Perform OCR text extraction
      await _extractText(image.path);

      setState(() {
        _isProcessing = false;
      });
    } catch (error) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Failed to capture image: $error';
      });
    }
  }

  Future<void> _extractText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text.isNotEmpty
            ? recognizedText.text
            : 'No text detected in image.';
      });
    } catch (error) {
      setState(() {
        _extractedText = 'Text extraction failed: $error';
      });
    }
  }

  Future<bool> _ensurePermissions() async {
    final cameraStatus = await Permission.camera.request();

    if (cameraStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return cameraStatus.isGranted || cameraStatus.isLimited;
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera / OCR'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Capture Button
              FilledButton.icon(
                onPressed: _isProcessing ? null : _captureImage,
                icon: _isProcessing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.camera_alt_outlined),
                label: Text(_isProcessing ? 'Processing...' : 'Capture Photo'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Error Message
              if (_errorMessage != null) ...[
                Card(
                  color: colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style:
                                TextStyle(color: colorScheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Captured Image Preview
              if (_capturedImage != null) ...[
                Text(
                  'Captured Image',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.file(
                      File(_capturedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Filename and Timestamp
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                _capturedImage!.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (_captureTimestamp != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: colorScheme.secondary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _formatTimestamp(_captureTimestamp!),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Extracted Text Section
                Text(
                  'Extracted Text (OCR)',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  elevation: 0,
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: _extractedText == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Extracting text...',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          )
                        : SelectableText(
                            _extractedText!,
                            style: textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                  ),
                ),
              ] else ...[
                // Empty State
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No photo captured yet',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Tap the button above to capture a photo containing text. The app will automatically extract any text from the image.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
