// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chemical.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChemicalImpl _$$ChemicalImplFromJson(Map<String, dynamic> json) =>
    _$ChemicalImpl(
      id: json['id'] as String,
      productName: json['productName'] as String,
      casNumber: json['casNumber'] as String,
      manufacturer: json['manufacturer'] as String,
      inventoryData: InventoryData.fromJson(
        json['inventoryData'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ChemicalImplToJson(_$ChemicalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'casNumber': instance.casNumber,
      'manufacturer': instance.manufacturer,
      'inventoryData': instance.inventoryData,
    };

_$InventoryDataImpl _$$InventoryDataImplFromJson(Map<String, dynamic> json) =>
    _$InventoryDataImpl(
      currentStock: (json['currentStock'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$$InventoryDataImplToJson(_$InventoryDataImpl instance) =>
    <String, dynamic>{
      'currentStock': instance.currentStock,
      'unit': instance.unit,
    };
