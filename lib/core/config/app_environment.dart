enum AppFlavor { development, production }

class AppEnvironment {
  const AppEnvironment._({
    required this.flavor,
    required this.baseApiUrl,
    required this.appTitle,
  });

  final AppFlavor flavor;
  final String baseApiUrl;
  final String appTitle;

  static late final AppEnvironment _current;

  static AppEnvironment get current => _current;

  static void init(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.development:
        _current = const AppEnvironment._(
          flavor: AppFlavor.development,
          baseApiUrl: 'https://dev.api.neotech.example/chemicals',
          appTitle: 'NeoTech Chemicals (Dev)',
        );
        break;
      case AppFlavor.production:
        _current = const AppEnvironment._(
          flavor: AppFlavor.production,
          baseApiUrl: 'https://api.neotech.example/chemicals',
          appTitle: 'NeoTech Chemical Inventory',
        );
        break;
    }
  }

  bool get isDevelopment => flavor == AppFlavor.development;
}
