// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_IconModel _$$_IconModelFromJson(Map<String, dynamic> json) => _$_IconModel(
      id: json['id'] as String,
      codepoint: json['codepoint'] as int,
      metadata: IconMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_IconModelToJson(_$_IconModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codepoint': instance.codepoint,
      'metadata': instance.metadata.toJson(),
    };
