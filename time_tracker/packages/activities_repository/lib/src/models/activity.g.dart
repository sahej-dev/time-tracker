// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Activity _$$_ActivityFromJson(Map<String, dynamic> json) => _$_Activity(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: IconModel.fromJson(json['icon'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as int?,
    );

Map<String, dynamic> _$$_ActivityToJson(_$_Activity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'icon': instance.icon.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'color': instance.color,
    };
