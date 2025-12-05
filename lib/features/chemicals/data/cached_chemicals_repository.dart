import 'package:hive_flutter/hive_flutter.dart';

import '../domain/chemical.dart';
import '../domain/chemicals_repository.dart';
import '../domain/dashboard_metrics.dart';
import 'chemical_cache.dart';
import 'chemicals_repository.dart';

/// Repository that provides cache-first data fetching strategy.
/// Fetches from cache first, then updates from network in background.
class CachedChemicalsRepository implements ChemicalsRepository {
  CachedChemicalsRepository({
    ChemicalsRepositoryImpl? networkRepository,
  }) : _networkRepository = networkRepository ?? ChemicalsRepositoryImpl();

  final ChemicalsRepositoryImpl _networkRepository;

  static const String _chemicalsBoxName = 'chemicals_cache';
  static const String _metricsBoxName = 'metrics_cache';
  static const String _metricsKey = 'dashboard_metrics';

  Box<ChemicalCache>? _chemicalsBox;
  Box<DashboardMetricsCache>? _metricsBox;

  /// Initialize Hive boxes
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChemicalCacheAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DashboardMetricsCacheAdapter());
    }

    _chemicalsBox = await Hive.openBox<ChemicalCache>(_chemicalsBoxName);
    _metricsBox = await Hive.openBox<DashboardMetricsCache>(_metricsBoxName);
  }

  @override
  Future<ChemicalsApiResponse> fetchChemicals() async {
    // Try to get cached data first
    final cachedResponse = _getCachedData();
    if (cachedResponse != null) {
      // Return cached data immediately, refresh in background
      _refreshFromNetwork();
      return cachedResponse;
    }

    // No cache, fetch from network
    try {
      final response = await _networkRepository.fetchChemicals();
      await _saveToCache(response);
      return response;
    } catch (e) {
      // If network fails and we have no cache, throw
      rethrow;
    }
  }

  /// Get data from local cache
  ChemicalsApiResponse? _getCachedData() {
    if (_chemicalsBox == null || _metricsBox == null) return null;
    if (_chemicalsBox!.isEmpty) return null;

    final chemicals = _chemicalsBox!.values
        .map((cache) => Chemical(
              id: cache.id,
              productName: cache.productName,
              casNumber: cache.casNumber,
              manufacturer: cache.manufacturer,
              stockQuantity: cache.stockQuantity,
              unit: cache.unit,
            ))
        .toList();

    final cachedMetrics = _metricsBox!.get(_metricsKey);
    final metrics = cachedMetrics != null
        ? DashboardMetrics(
            totalChemicals: cachedMetrics.totalChemicals,
            activeSDSDocuments: cachedMetrics.activeSDSDocuments,
            recentIncidents: cachedMetrics.recentIncidents,
          )
        : DashboardMetrics(
            totalChemicals: chemicals.length,
            activeSDSDocuments: chemicals.length,
            recentIncidents: 0,
          );

    return ChemicalsApiResponse(chemicals: chemicals, metrics: metrics);
  }

  /// Refresh data from network in background
  Future<void> _refreshFromNetwork() async {
    try {
      final response = await _networkRepository.fetchChemicals();
      await _saveToCache(response);
    } catch (_) {
      // Silently fail background refresh
    }
  }

  /// Save data to local cache
  Future<void> _saveToCache(ChemicalsApiResponse response) async {
    if (_chemicalsBox == null || _metricsBox == null) return;

    // Clear and save chemicals
    await _chemicalsBox!.clear();
    for (final chemical in response.chemicals) {
      await _chemicalsBox!.add(ChemicalCache(
        id: chemical.id,
        productName: chemical.productName,
        casNumber: chemical.casNumber,
        manufacturer: chemical.manufacturer,
        stockQuantity: chemical.stockQuantity,
        unit: chemical.unit,
      ));
    }

    // Save metrics
    await _metricsBox!.put(
      _metricsKey,
      DashboardMetricsCache(
        totalChemicals: response.metrics.totalChemicals,
        activeSDSDocuments: response.metrics.activeSDSDocuments,
        recentIncidents: response.metrics.recentIncidents,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _chemicalsBox?.clear();
    await _metricsBox?.clear();
  }
}
