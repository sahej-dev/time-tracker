// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_IconMetadata _$$_IconMetadataFromJson(Map<String, dynamic> json) =>
    _$_IconMetadata(
      id: json['id'] as String,
      fontFamily: json['font_family'] as String?,
      fontPackage: json['font_package'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_IconMetadataToJson(_$_IconMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'font_family': instance.fontFamily,
      'font_package': instance.fontPackage,
      'createdAt': instance.createdAt.toIso8601String(),
    };
