import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_instance.freezed.dart';
part 'activity_instance.g.dart';

@freezed
class ActivityInstance with _$ActivityInstance {
  @JsonSerializable(explicitToJson: true)
  const factory ActivityInstance({
    String? id,
    @JsonKey(name: 'start_at') required DateTime startAt,
    @JsonKey(name: 'end_at') DateTime? endAt,
    String? comment,
    @JsonKey(name: 'activity_id') required String activityId,
    DateTime? createdAt,
  }) = _ActivityInstance;

  factory ActivityInstance.fromJson(Map<String, dynamic> json) =>
      _$ActivityInstanceFromJson(json);
}
