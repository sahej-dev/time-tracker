// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Icon _$$_IconFromJson(Map<String, dynamic> json) => _$_Icon(
      id: json['id'] as String,
      codepoint: json['codepoint'] as int,
      metadata:
          IconMetadata.fromJson(json['icon_metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_IconToJson(_$_Icon instance) => <String, dynamic>{
      'id': instance.id,
      'codepoint': instance.codepoint,
      'icon_metadata': instance.metadata,
    };
