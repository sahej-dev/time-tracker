import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_instance.dart';

part 'network_activity_instance.freezed.dart';
part 'network_activity_instance.g.dart';

@freezed
class NetworkActivityInstance with _$NetworkActivityInstance {
  const NetworkActivityInstance._();

  @JsonSerializable(explicitToJson: true)
  const factory NetworkActivityInstance({
    String? id,
    @DateTimeConverter() @JsonKey(name: 'start_at') required DateTime startAt,
    @DateTimeConverterNullable() @JsonKey(name: 'end_at') DateTime? endAt,
    String? comment,
    @JsonKey(name: 'activity_id') required String activityId,
    @DateTimeConverterNullable() DateTime? createdAt,
  }) = _NetworkActivityInstance;

  factory NetworkActivityInstance.fromJson(Map<String, dynamic> json) =>
      _$NetworkActivityInstanceFromJson(json);

  ActivityInstance asExternalInstance() {
    return ActivityInstance(
      id: id,
      startAt: startAt,
      endAt: endAt,
      activityId: activityId,
      comment: comment,
      createdAt: createdAt,
    );
  }
}

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime value) => value.toUtc().toIso8601String();
}

class DateTimeConverterNullable implements JsonConverter<DateTime?, String?> {
  const DateTimeConverterNullable();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json).toLocal();

  @override
  String? toJson(DateTime? value) => value?.toUtc().toIso8601String();
}
