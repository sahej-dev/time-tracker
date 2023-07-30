// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NetworkActivity _$$_NetworkActivityFromJson(Map<String, dynamic> json) =>
    _$_NetworkActivity(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: IconModel.fromJson(json['icon'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as int?,
    );

Map<String, dynamic> _$$_NetworkActivityToJson(_$_NetworkActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'icon': instance.icon.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'color': instance.color,
    };
