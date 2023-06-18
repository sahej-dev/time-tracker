// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActivityInstance _$$_ActivityInstanceFromJson(Map<String, dynamic> json) =>
    _$_ActivityInstance(
      id: json['id'] as String?,
      startAt: const DateTimeConverter().fromJson(json['start_at'] as String),
      endAt:
          const DateTimeConverterNullable().fromJson(json['end_at'] as String?),
      comment: json['comment'] as String?,
      activityId: json['activity_id'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_ActivityInstanceToJson(_$_ActivityInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_at': const DateTimeConverter().toJson(instance.startAt),
      'end_at': const DateTimeConverterNullable().toJson(instance.endAt),
      'comment': instance.comment,
      'activity_id': instance.activityId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
