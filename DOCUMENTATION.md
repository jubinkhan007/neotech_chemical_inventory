# NeoTech Chemical Inventory
## Flutter Mobile Developer Test Submission

**Candidate**: [Your Name]  
**Date**: December 2024  
**Flutter Version**: 3.35.3  
**Dart Version**: 3.9.2

---

# Table of Contents

1. [Installation Instructions](#1-installation-instructions)
2. [Architecture Overview](#2-architecture-overview)
3. [Run Instructions](#3-run-instructions)
4. [Conceptual / Architecture Tasks](#4-conceptual--architecture-tasks)
   - 4A. Image Recognition Workflow
   - 4B. Direct Mobile Data Entry
   - 4C. Real-Time Compliance Monitoring
5. [Feature Screenshots](#5-feature-screenshots)

---

# 1. Installation Instructions

## Required Versions
- **Flutter**: 3.35.3 or higher
- **Dart**: 3.9.2 or higher
- **Android SDK**: 21+ (Android 5.0 Lollipop)
- **iOS**: 12.0+

## Install Dependencies

```bash
# Clone repository
git clone https://github.com/jubinkhan007/neotech_chemical_inventory.git
cd neotech_chemical_inventory

# Install Flutter packages
flutter pub get

# Generate Freezed models
flutter pub run build_runner build --delete-conflicting-outputs
```

## Camera Permission Requirements

### Android
The following permission is declared in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

### iOS
The following key is added to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to capture chemical labels for text recognition.</string>
```

---

# 2. Architecture Overview

## Folder Structure

```
lib/
├── app.dart                     # Root app widget with theme configuration
├── main.dart                    # Entry point with Hive initialization
├── core/
│   ├── config/                  # Environment configuration
│   │   └── app_environment.dart
│   ├── network/                 # HTTP client wrapper
│   │   └── api_client.dart
│   ├── router/                  # Navigation with GoRouter
│   │   └── app_router.dart
│   └── ui/                      # Design system
│       ├── app_colors.dart
│       ├── app_spacing.dart
│       ├── app_text_theme.dart
│       └── app_theme.dart       # Light + Dark themes
└── features/
    ├── camera/
    │   └── presentation/
    │       └── camera_screen.dart   # Camera + OCR extraction
    ├── chemicals/
    │   ├── data/
    │   │   ├── cached_chemicals_repository.dart  # Hive cache
    │   │   ├── chemical_cache.dart               # Hive adapters
    │   │   ├── chemicals_repository.dart         # API implementation
    │   │   └── mock_chemicals_repository.dart
    │   ├── domain/
    │   │   ├── chemical.dart                     # Domain model
    │   │   ├── chemicals_repository.dart         # Repository interface
    │   │   └── dashboard_metrics.dart
    │   ├── models/
    │   │   └── chemical.dart                     # Freezed data model
    │   └── presentation/
    │       ├── chemicals_notifier.dart           # State management
    │       ├── chemicals_screen.dart             # List UI
    │       └── chemicals_state.dart
    ├── dashboard/
    │   └── presentation/
    │       └── dashboard_screen.dart             # Dashboard with metrics
    └── data_entry/
        └── presentation/
            └── data_entry_screen.dart            # Form entry
```

## State Management

The application uses **ValueNotifier + ChangeNotifier** for simple, reactive state management:

- **ChemicalsNotifier**: Extends `ChangeNotifier` to manage chemical list and dashboard metrics
- **ChemicalsState**: Sealed class representing loading, error, empty, and success states
- **Riverpod**: Used for dependency injection (GoRouter provider)

This approach was chosen for:
- Simplicity and minimal boilerplate
- Built-in Flutter support (no external dependencies)
- Easy testing and debugging

## Key Design Decisions

1. **Cache-First Strategy**: Data is loaded from Hive cache immediately, then refreshed from network in background. This provides instant UI response even offline.

2. **Feature-Based Architecture**: Each feature is self-contained with data/domain/presentation layers, enabling easy maintenance and testing.

3. **Freezed Models**: Immutable data classes with automatic JSON serialization reduce boilerplate and prevent mutation bugs.

4. **Theme System**: Centralized theme configuration with Material 3 support for both light and dark modes.

---

# 3. Run Instructions

## Step-by-Step Guide

### 1. Verify Flutter Installation
```bash
flutter doctor
```
Ensure all checkmarks pass for your target platform.

### 2. Install Dependencies
```bash
cd neotech_chemical_inventory
flutter pub get
```

### 3. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run on Android
```bash
# Start Android emulator or connect device
flutter run -d android

# Or build release APK
flutter build apk
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### 5. Run on iOS
```bash
# Start iOS simulator or connect device
flutter run -d ios

# Or build for release
flutter build ios
```

## Testing Main Features

| Feature | Steps |
|---------|-------|
| **Dashboard Metrics** | Launch app → View 3 metric cards at top |
| **Chemicals List** | Tap "View Chemicals" → See 3 chemicals from API |
| **Camera/OCR** | Tap "Scan Label" → Capture photo → View extracted text |
| **Data Entry** | Tap "Add Entry" → Fill form → Tap Save |
| **Dark Mode** | Switch device to dark mode → App updates automatically |
| **Offline Mode** | Disable internet → Pull to refresh → Cached data shown |

---

# 4. Conceptual / Architecture Tasks

## 4A. Image Recognition Workflow (Concept Only)

### Recommended OCR Solution

For a production chemical inventory application, I would recommend **Google ML Kit Text Recognition** (currently implemented) with additional processing layers:

1. **Google ML Kit Text Recognition** (on-device)
   - Fast, offline-capable processing
   - No API costs or latency
   - Supports Latin-based scripts

2. **For complex scenarios**, consider **Google Cloud Vision API**:
   - Higher accuracy for printed labels
   - Supports 100+ languages
   - Better handling of curved or distorted text

### Extracting Chemical Information

The extraction workflow would involve:

1. **Text Extraction**: Capture image → ML Kit extracts raw text blocks
2. **Pattern Matching**: Apply regex patterns to identify:
   - **CAS Number**: Pattern `\d{2,7}-\d{2}-\d` (e.g., 7647-14-5)
   - **Chemical Name**: NLP-based entity recognition or dictionary lookup
   - **Manufacturer**: Match against known manufacturer database
3. **Structured Output**: Map extracted values to `Chemical` model

### Confidence Scoring & Validation

- **ML Kit Confidence**: Each `TextBlock` includes confidence scores (0.0-1.0)
- **Threshold Filtering**: Only accept extractions with >0.85 confidence
- **User Validation**: Display extracted values for user confirmation
- **Cross-Reference**: Validate CAS numbers against PubChem database
- **Fuzzy Matching**: Use Levenshtein distance for manufacturer name matching

---

## 4B. Direct Mobile Data Entry (Concept + Implementation)

### Implementation

The Data Entry screen (`data_entry_screen.dart`) includes:

- **Quantity Input**: TextFormField with decimal keyboard and validation
- **Storage Location (Dropdown)**: Preset options (Flammable storage, Cold room, etc.)
- **Storage Location (Free Text)**: Custom location input
- **Save Button**: Mock save with snackbar confirmation

### Offline → Online Sync Strategy

1. **Local Queue Storage**
   ```dart
   class PendingEntry {
     final String chemicalId;
     final double quantity;
     final String location;
     final DateTime timestamp;
     final String deviceId;
   }
   ```

2. **Write to Local Queue**
   - On save, write to Hive box `pending_entries`
   - Include timestamp and device ID for conflict resolution

3. **Background Sync Service**
   - Use `workmanager` package for periodic background sync
   - Check connectivity with `connectivity_plus`
   - When online, upload pending entries in order

4. **Conflict Resolution**
   - Server compares timestamps
   - Last-write-wins for simple conflicts
   - User prompt for complex conflicts (e.g., same chemical edited on two devices)

5. **Sync Status UI**
   - Badge on dashboard showing pending sync count
   - Pull-to-refresh triggers immediate sync attempt

---

## 4C. Real-Time Compliance Monitoring (Concept Only)

### Push and Receive Real-Time Alerts

The application would use **Firebase Cloud Messaging (FCM)** for push notifications combined with **WebSocket** for live data:

1. **Firebase Cloud Messaging**
   - Push compliance alerts even when app is closed
   - High-priority alerts for critical compliance violations
   - Topic-based subscription (e.g., `compliance_alerts_site_1`)

2. **WebSocket Connection**
   - Persistent connection for real-time UI updates
   - Use `web_socket_channel` package
   - Automatic reconnection with exponential backoff

### Live UI Updates

```dart
class ComplianceNotifier extends ChangeNotifier {
  StreamSubscription? _wsSubscription;
  
  void connectWebSocket() {
    final channel = WebSocketChannel.connect(Uri.parse('wss://api.neotech.com/ws'));
    _wsSubscription = channel.stream.listen((message) {
      final alert = ComplianceAlert.fromJson(jsonDecode(message));
      _alerts.insert(0, alert);
      notifyListeners(); // UI rebuilds immediately
    });
  }
}
```

- **SnackBar/Banner**: Non-intrusive alerts for low-priority items
- **Dialog**: Modal for critical compliance violations
- **Badge Counter**: Real-time count on dashboard

### Offline vs Online Behavior

| Scenario | Behavior |
|----------|----------|
| **Online** | WebSocket receives live alerts, immediately display |
| **Offline** | Cache last known alerts in Hive, show "Last updated X minutes ago" |
| **Reconnection** | Fetch missed alerts from REST API, merge with cached data |

**Offline Resilience**:
- Store alerts in Hive with timestamp
- On reconnect, request alerts since `lastSyncTimestamp`
- Deduplicate by alert ID before displaying

---

# 5. Feature Screenshots

*[Add screenshots of Dashboard, Chemicals List, Camera/OCR, Data Entry, Dark Mode here]*

---

# Summary

This submission demonstrates a complete, production-ready Flutter application with:

✅ Async API integration with error handling  
✅ Clean chemical list with card layout  
✅ Dashboard metrics display  
✅ Camera capture with OCR text extraction  
✅ Data entry form with validation  
✅ Offline caching (Hive)  
✅ Dark mode support  
✅ Smooth animations  
✅ Comprehensive documentation  

The architecture follows clean code principles with feature-based organization, making it maintainable and scalable for future enhancements.
