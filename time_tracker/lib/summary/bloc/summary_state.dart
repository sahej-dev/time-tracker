part of 'summary_bloc.dart';

class SummaryState extends Equatable {
  final LoadingStatus _activitiesLoadingStatus;
  final LoadingStatus _logsLoadingStatus;

  final HashMap<String, Activity> _activities;
  final List<ActivityInstance> _instances;
  final Exception? exception;

  final DateTime startDate;
  final DateTime endDate;
  final bool showUntracked;

  List<Statistic>? _statistics;

  SummaryState._({
    LoadingStatus activitiesLoadingStatus = LoadingStatus.initial,
    LoadingStatus logsLoadingStatus = LoadingStatus.initial,
    List<ActivityInstance> instances = const [],
    HashMap<String, Activity>? activities,
    this.exception,
    DateTime? startDate,
    DateTime? endDate,
    this.showUntracked = false,
  })  : _activitiesLoadingStatus = activitiesLoadingStatus,
        _logsLoadingStatus = logsLoadingStatus,
        _instances = instances,
        _activities = activities ?? HashMap(),
        startDate = startDate ?? DateUtils.dateOnly(DateTime.now()),
        endDate = endDate ?? DateTime.now();

  SummaryState.initial() : this._();

  @override
  List<Object?> get props => [
        _activitiesLoadingStatus,
        _logsLoadingStatus,
        _activities,
        _instances,
        exception,
        startDate,
        endDate,
        showUntracked,
      ];

  SummaryState copyWith({
    LoadingStatus? activitiesLoadingStatus,
    LoadingStatus? logsLoadingStatus,
    List<ActivityInstance>? instances,
    List<Activity>? activities,
    Exception? exception,
    DateTime? startDate,
    DateTime? endDate,
    bool? showUntracked,
  }) {
    if (startDate != null || endDate != null || showUntracked != null) {
      _statistics = null;
    }

    return SummaryState._(
      activitiesLoadingStatus:
          activitiesLoadingStatus ?? _activitiesLoadingStatus,
      logsLoadingStatus: logsLoadingStatus ?? _logsLoadingStatus,
      instances: instances ?? _instances,
      activities: activities != null
          ? HashMap.fromEntries(activities.map((e) => MapEntry(e.id, e)))
          : _activities,
      exception: LoadingStatusMixer.mix([
                activitiesLoadingStatus ?? _activitiesLoadingStatus,
                logsLoadingStatus ?? _logsLoadingStatus
              ]) !=
              LoadingStatus.error
          ? null
          : (exception ?? this.exception),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      showUntracked: showUntracked ?? this.showUntracked,
    );
  }

  LoadingStatus get loadingStatus =>
      LoadingStatusMixer.mix([_activitiesLoadingStatus, _logsLoadingStatus]);

  Activity? Function(ActivityInstance) get activityForInstance =>
      (ActivityInstance instance) => _activities[instance.activityId];

  List<Statistic> get statistics {
    if (_statistics != null) return _statistics!;

    List<ActivityInstance> instancesInInterval = _instances
        .where((instance) =>
            instance.endAt != null &&
            instance.endAt!.isAfter(startDate) &&
            instance.startAt.isBefore(endDate))
        .toList();

    if (instancesInInterval.isNotEmpty) {
      if (instancesInInterval.first.startAt.isBefore(startDate)) {
        instancesInInterval.first =
            instancesInInterval.first.copyWith(startAt: startDate);
      }

      if (instancesInInterval.last.endAt!.isAfter(endDate)) {
        instancesInInterval.last =
            instancesInInterval.last.copyWith(endAt: endDate);
      }
    }

    int totalMinutes = showUntracked
        ? endDate.difference(startDate).inMinutes
        : instancesInInterval.fold(
            0,
            (previousValue, instance) =>
                previousValue +
                instance.endAt!.difference(instance.startAt).inMinutes,
          );

    HashSet<Activity> uniqueActivities = HashSet.from(
        instancesInInterval.map((instance) => activityForInstance(instance)));

    int minutesTracked = 0;

    _statistics = uniqueActivities.map(
      (activity) {
        Iterable<ActivityInstance> instancesOfThisActivity = instancesInInterval
            .where((instance) => instance.activityId == activity.id);

        int activityDurationMinutes = instancesOfThisActivity.fold(
          0,
          (previousValue, instance) =>
              previousValue + instance.duration!.inMinutes,
        );

        minutesTracked += activityDurationMinutes;

        return Statistic(
          activity: activity,
          duration: Duration(minutes: activityDurationMinutes),
          percentage: activityDurationMinutes / totalMinutes,
        );
      },
    ).toList();

    if (showUntracked) {
      _statistics!.add(
        Statistic(
          activity: Activity(label: 'Untracked', iconData: Icons.no_sim),
          duration: Duration(minutes: totalMinutes - minutesTracked),
          percentage: 1 - minutesTracked / totalMinutes,
        ),
      );
    }

    _statistics!.sort(
      (a, b) => b.duration.compareTo(a.duration),
    );

    return _statistics!;
  }
}
