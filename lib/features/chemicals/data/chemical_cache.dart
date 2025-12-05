import 'package:hive/hive.dart';

/// Hive adapter for caching chemicals locally
class ChemicalCache extends HiveObject {
  ChemicalCache({
    required this.id,
    required this.productName,
    required this.casNumber,
    required this.manufacturer,
    required this.stockQuantity,
    required this.unit,
  });

  String id;
  String productName;
  String casNumber;
  String manufacturer;
  double stockQuantity;
  String unit;
}

/// Hive adapter for caching dashboard metrics
class DashboardMetricsCache extends HiveObject {
  DashboardMetricsCache({
    required this.totalChemicals,
    required this.activeSDSDocuments,
    required this.recentIncidents,
    required this.lastUpdated,
  });

  int totalChemicals;
  int activeSDSDocuments;
  int recentIncidents;
  DateTime lastUpdated;
}

/// Manual Hive TypeAdapter for ChemicalCache
class ChemicalCacheAdapter extends TypeAdapter<ChemicalCache> {
  @override
  final int typeId = 0;

  @override
  ChemicalCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChemicalCache(
      id: fields[0] as String,
      productName: fields[1] as String,
      casNumber: fields[2] as String,
      manufacturer: fields[3] as String,
      stockQuantity: fields[4] as double,
      unit: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChemicalCache obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.casNumber)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.stockQuantity)
      ..writeByte(5)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChemicalCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Manual Hive TypeAdapter for DashboardMetricsCache
class DashboardMetricsCacheAdapter extends TypeAdapter<DashboardMetricsCache> {
  @override
  final int typeId = 1;

  @override
  DashboardMetricsCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardMetricsCache(
      totalChemicals: fields[0] as int,
      activeSDSDocuments: fields[1] as int,
      recentIncidents: fields[2] as int,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardMetricsCache obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalChemicals)
      ..writeByte(1)
      ..write(obj.activeSDSDocuments)
      ..writeByte(2)
      ..write(obj.recentIncidents)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardMetricsCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
