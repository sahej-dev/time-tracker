part of 'logs_bloc.dart';

class LogsState extends Equatable {
  final LoadingStatus _activitiesLoadingStatus;
  final LoadingStatus _logsLoadingStatus;

  final HashMap<String, Activity> _activities;
  final List<ActivityInstance> instances;
  final Exception? exception;
  final ActivityInstance? lastDeleted;

  LogsState._({
    LoadingStatus activitiesLoadingStatus = LoadingStatus.initial,
    LoadingStatus logsLoadingStatus = LoadingStatus.initial,
    this.instances = const [],
    HashMap<String, Activity>? activities,
    this.exception,
    this.lastDeleted,
  })  : _activitiesLoadingStatus = activitiesLoadingStatus,
        _logsLoadingStatus = logsLoadingStatus,
        _activities = activities ?? HashMap();

  LogsState.initial() : this._();

  @override
  List<Object?> get props => [
        _activitiesLoadingStatus,
        _logsLoadingStatus,
        instances,
        exception,
        lastDeleted,
        _activities,
      ];

  LogsState copyWith({
    LoadingStatus? activitiesLoadingStatus,
    LoadingStatus? logsLoadingStatus,
    List<ActivityInstance>? instances,
    List<Activity>? activities,
    Exception? exception,
    ActivityInstance? lastDeleted,
  }) {
    return LogsState._(
      activitiesLoadingStatus:
          activitiesLoadingStatus ?? _activitiesLoadingStatus,
      logsLoadingStatus: logsLoadingStatus ?? _logsLoadingStatus,
      instances: instances ?? this.instances,
      lastDeleted: lastDeleted ?? this.lastDeleted,
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
    );
  }

  LoadingStatus get loadingStatus =>
      LoadingStatusMixer.mix([_activitiesLoadingStatus, _logsLoadingStatus]);

  ActivityInstance? get runningInstance {
    int idx = instances.indexWhere((instance) => instance.endAt == null);
    if (idx < 0) return null;

    return instances[idx];
  }

  Activity? Function(ActivityInstance) get activityForInstance =>
      (ActivityInstance instance) => _activities[instance.activityId];
}
