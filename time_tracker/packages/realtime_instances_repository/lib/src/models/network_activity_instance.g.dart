// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_activity_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NetworkActivityInstance _$$_NetworkActivityInstanceFromJson(
        Map<String, dynamic> json) =>
    _$_NetworkActivityInstance(
      id: json['id'] as String?,
      startAt: const DateTimeConverter().fromJson(json['start_at'] as String),
      endAt:
          const DateTimeConverterNullable().fromJson(json['end_at'] as String?),
      comment: json['comment'] as String?,
      activityId: json['activity_id'] as String,
      createdAt: const DateTimeConverterNullable()
          .fromJson(json['createdAt'] as String?),
    );

Map<String, dynamic> _$$_NetworkActivityInstanceToJson(
        _$_NetworkActivityInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_at': const DateTimeConverter().toJson(instance.startAt),
      'end_at': const DateTimeConverterNullable().toJson(instance.endAt),
      'comment': instance.comment,
      'activity_id': instance.activityId,
      'createdAt': const DateTimeConverterNullable().toJson(instance.createdAt),
    };
