import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'network_activity_instance.dart';

part 'activity_instance.freezed.dart';

@freezed
class ActivityInstance with _$ActivityInstance {
  const ActivityInstance._();

  const factory ActivityInstance._def({
    required String id,
    required DateTime startAt,
    required String activityId,
    required DateTime createdAt,
    DateTime? endAt,
    String? comment,
  }) = _ActivityInstance;

  factory ActivityInstance({
    required String activityId,
    String? id,
    DateTime? startAt,
    DateTime? endAt,
    String? comment,
    DateTime? createdAt,
  }) {
    final uuid = Uuid();
    return ActivityInstance._def(
      id: id ?? uuid.v4(),
      startAt: startAt ?? DateTime.now(),
      activityId: activityId,
      createdAt: createdAt ?? DateTime.now(),
      endAt: endAt,
      comment: comment,
    );
  }

  NetworkActivityInstance asNetworkInstance() {
    return NetworkActivityInstance(
        id: id,
        startAt: startAt,
        endAt: endAt,
        activityId: activityId,
        comment: comment,
        createdAt: createdAt);
  }
}
