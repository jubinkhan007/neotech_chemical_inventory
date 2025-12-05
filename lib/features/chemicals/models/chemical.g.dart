// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chemical.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChemicalImpl _$$ChemicalImplFromJson(Map<String, dynamic> json) => _$ChemicalImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      casNumber: json['cas_number'] as String,
      storageLocation: json['storage_location'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$ChemicalImplToJson(_$ChemicalImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cas_number': instance.casNumber,
      'storage_location': instance.storageLocation,
      'quantity': instance.quantity,
    };
