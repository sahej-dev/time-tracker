import 'package:instances_repository/instances_repository.dart';

extension DurationGenerator on ActivityInstance {
  Duration? get duration => endAt == null ? null : endAt!.difference(startAt);

  Duration get startSinceNow => startAt.difference(DateTime.now());
}
