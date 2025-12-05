// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'chemical.dart';

_$$ChemicalFromJson(Map<String, dynamic> json) => _Chemical(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ChemicalToJson(_Chemical instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
