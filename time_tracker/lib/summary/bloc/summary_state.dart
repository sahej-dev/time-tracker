part of 'summary_bloc.dart';

class SummaryState extends Equatable {
  final LoadingStatus _activitiesLoadingStatus;
  final LoadingStatus _logsLoadingStatus;

  final HashMap<String, Activity> _activities;
  final List<ActivityInstance> _instances;
  final Exception? exception;

  SummaryState._({
    LoadingStatus activitiesLoadingStatus = LoadingStatus.initial,
    LoadingStatus logsLoadingStatus = LoadingStatus.initial,
    List<ActivityInstance> instances = const [],
    HashMap<String, Activity>? activities,
    this.exception,
  })  : _activitiesLoadingStatus = activitiesLoadingStatus,
        _logsLoadingStatus = logsLoadingStatus,
        _instances = instances,
        _activities = activities ?? HashMap();

  SummaryState.initial() : this._();

  @override
  List<Object?> get props => [
        _activitiesLoadingStatus,
        _logsLoadingStatus,
        _activities,
        _instances,
        exception
      ];

  SummaryState copyWith({
    LoadingStatus? activitiesLoadingStatus,
    LoadingStatus? logsLoadingStatus,
    List<ActivityInstance>? instances,
    List<Activity>? activities,
    Exception? exception,
  }) {
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
    );
  }

  LoadingStatus get loadingStatus =>
      LoadingStatusMixer.mix([_activitiesLoadingStatus, _logsLoadingStatus]);

  Activity? Function(ActivityInstance) get activityForInstance =>
      (ActivityInstance instance) => _activities[instance.activityId];
}
