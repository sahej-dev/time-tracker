// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActivityInstance _$$_ActivityInstanceFromJson(Map<String, dynamic> json) =>
    _$_ActivityInstance(
      id: json['id'] as String,
      startAt: DateTime.parse(json['start_at'] as String),
      endAt: json['end_at'] == null
          ? null
          : DateTime.parse(json['end_at'] as String),
      comment: json['comment'] as String?,
      activityId: json['activity_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_ActivityInstanceToJson(_$_ActivityInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_at': instance.startAt.toIso8601String(),
      'end_at': instance.endAt?.toIso8601String(),
      'comment': instance.comment,
      'activity_id': instance.activityId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
