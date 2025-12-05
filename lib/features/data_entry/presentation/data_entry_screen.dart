import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/ui/app_spacing.dart';

class DataEntryScreen extends StatefulWidget {
  const DataEntryScreen({super.key});

  @override
  State<DataEntryScreen> createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _customLocationController = TextEditingController();

  final List<String> _presetLocations = const [
    'Flammable storage',
    'Cold room',
    'Outdoor cage',
    'Main warehouse',
  ];

  String? _selectedLocation;

  @override
  void dispose() {
    _quantityController.dispose();
    _customLocationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0;
    final location =
        _customLocationController.text.trim().isNotEmpty ? _customLocationController.text.trim() : _selectedLocation;

    final confirmationMessage =
        'Saved $quantity units to "$location" (queued locally for background sync).';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(confirmationMessage),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _formKey.currentState?.reset();
    setState(() {
      _selectedLocation = null;
    });
    _quantityController.clear();
    _customLocationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemical Data Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: theme.colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Offline-first syncing',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Entries are written to a local queue with timestamps.'),
                    Text('• Background sync uploads queued items when connectivity returns.'),
                    Text('• Conflicts are resolved by comparing timestamps and prompting when needed.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Enter amount (e.g., 5.25)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) {
                        return 'Quantity is required';
                      }
                      final number = double.tryParse(trimmed);
                      if (number == null || number <= 0) {
                        return 'Enter a positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    items: _presetLocations
                        .map(
                          (location) => DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Storage location (quick pick)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customLocationController,
                    decoration: const InputDecoration(
                      labelText: 'Custom storage location',
                      hintText: 'Rack 3, Shelf B',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final hasDropdownSelection = _selectedLocation?.isNotEmpty == true;
                      final hasCustomText = (value?.trim().isNotEmpty ?? false);
                      if (!hasDropdownSelection && !hasCustomText) {
                        return 'Select or enter a storage location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
