import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_instance.freezed.dart';
part 'activity_instance.g.dart';

@freezed
class ActivityInstance with _$ActivityInstance {
  @JsonSerializable(explicitToJson: true)
  const factory ActivityInstance({
    String? id,
    @DateTimeConverter() @JsonKey(name: 'start_at') required DateTime startAt,
    @DateTimeConverter() @JsonKey(name: 'end_at') DateTime? endAt,
    String? comment,
    @JsonKey(name: 'activity_id') required String activityId,
    DateTime? createdAt,
  }) = _ActivityInstance;

  factory ActivityInstance.fromJson(Map<String, dynamic> json) =>
      _$ActivityInstanceFromJson(json);
}

class DateTimeConverter implements JsonConverter<DateTime?, String?> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json).toLocal();

  @override
  String? toJson(DateTime? value) => value?.toUtc().toIso8601String();
}
