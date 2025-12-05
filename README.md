# NeoTech Chemical Inventory

A production-ready Flutter application for chemical inventory management with OCR text recognition, offline caching, and real-time dashboard metrics.

## Features

- 📊 **Dashboard** - Real-time metrics (total chemicals, SDS documents, incidents)
- 🧪 **Chemicals List** - Scrollable list with product details, CAS numbers, stock levels
- 📷 **Camera + OCR** - Capture photos and extract text using Google ML Kit
- 📝 **Data Entry** - Quantity input with dropdown/custom storage locations
- 🌙 **Dark Mode** - Automatic system theme detection
- 💾 **Offline Caching** - Hive-powered cache-first data fetching
- ✨ **Animations** - Smooth page transitions and staggered list animations

## Requirements

- **Flutter**: 3.35.3 or higher
- **Dart**: 3.9.2 or higher
- **Android**: SDK 21+ (Android 5.0 Lollipop)
- **iOS**: 12.0+

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/jubinkhan007/neotech_chemical_inventory.git
cd neotech_chemical_inventory
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Generate code (Freezed models)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Run the App

### Android
```bash
# Debug mode
flutter run -d android

# Release APK
flutter build apk
```

### iOS
```bash
# Debug mode
flutter run -d ios

# Release build
flutter build ios
```

## Camera Permissions

The app requires camera permissions for the OCR feature:

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to capture chemical labels for text recognition.</string>
```

## Testing Main Features

1. **Dashboard**: Launch app → View metrics cards (Total Chemicals, Active SDS, Incidents)
2. **Chemicals List**: Tap "View Chemicals" → See list of 3 chemicals from API
3. **Camera/OCR**: Tap "Scan Label" → Capture photo → View extracted text
4. **Data Entry**: Tap "Add Entry" → Enter quantity and location → Save
5. **Dark Mode**: Switch device to dark mode → App theme updates automatically
6. **Offline Mode**: Turn off internet → Pull to refresh → Cached data displayed

## Architecture

```
lib/
├── app.dart                     # App widget with theme config
├── main.dart                    # Entry point with Hive init
├── core/
│   ├── config/                  # Environment configuration
│   ├── network/                 # API client
│   ├── router/                  # GoRouter navigation
│   └── ui/                      # Theme, colors, spacing
└── features/
    ├── camera/                  # Camera + OCR feature
    ├── chemicals/               # Chemicals list + dashboard data
    │   ├── data/                # Repository implementations
    │   ├── domain/              # Domain models
    │   ├── models/              # Freezed data models
    │   └── presentation/        # UI + state management
    ├── dashboard/               # Dashboard screen
    └── data_entry/              # Data entry form
```

### State Management
- **ValueNotifier** for simple reactive state
- **Riverpod** for dependency injection (GoRouter)

### Key Design Decisions
- **Cache-first strategy**: Cached data shown immediately, network refresh in background
- **Freezed models**: Immutable data classes with JSON serialization
- **Feature-based folders**: Each feature is self-contained with data/domain/presentation layers

## API

The app fetches chemical data from:
```
https://api.jsonbin.io/v3/b/68918782f7e7a370d1f4029d
```

Response includes:
- `record.chemicals[]` - Array of chemical objects
- `record.dashboardMetrics` - Metrics for dashboard display

## Dependencies

| Package | Purpose |
|---------|---------|
| `go_router` | Declarative routing |
| `hive_flutter` | Offline caching |
| `google_mlkit_text_recognition` | OCR text extraction |
| `image_picker` | Camera/gallery access |
| `freezed` | Immutable data classes |
| `hooks_riverpod` | State management |
| `http` | API calls |

## License

MIT License
