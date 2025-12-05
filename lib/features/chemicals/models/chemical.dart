import 'package:freezed_annotation/freezed_annotation.dart';

part 'chemical.freezed.dart';
part 'chemical.g.dart';

@freezed
class Chemical with _$Chemical {
  const factory Chemical({
    required String id,
    required String productName,
    required String casNumber,
    required String manufacturer,
    required InventoryData inventoryData,
  }) = _Chemical;

  factory Chemical.fromJson(Map<String, dynamic> json) =>
      _$ChemicalFromJson(json);
}

@freezed
class InventoryData with _$InventoryData {
  const factory InventoryData({
    required double currentStock,
    required String unit,
  }) = _InventoryData;

  factory InventoryData.fromJson(Map<String, dynamic> json) =>
      _$InventoryDataFromJson(json);
}
