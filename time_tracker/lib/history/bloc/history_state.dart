part of 'history_bloc.dart';

// ignore: must_be_immutable
class HistoryState extends Equatable {
  final LoadingStatus _activitiesLoadingStatus;
  final LoadingStatus _logsLoadingStatus;

  final HashMap<String, Activity> _activities;
  final List<ActivityInstance> _instances;
  final List<ActivityInstance> selectedInstances;

  final List<ActivityInstance>? lastDeleted;

  final Exception? exception;

  HistoryState._({
    LoadingStatus activitiesLoadingStatus = LoadingStatus.initial,
    LoadingStatus logsLoadingStatus = LoadingStatus.initial,
    HashMap<String, Activity>? activities,
    List<ActivityInstance> instances = const [],
    this.exception,
    this.selectedInstances = const [],
    this.lastDeleted,
  })  : _instances = instances,
        _activitiesLoadingStatus = activitiesLoadingStatus,
        _logsLoadingStatus = logsLoadingStatus,
        _activities = activities ?? HashMap();

  HistoryState.initial() : this._();

  @override
  List<Object?> get props => [
        _logsLoadingStatus,
        _activitiesLoadingStatus,
        _activities,
        _instances,
        exception,
        loadingStatus,
        selectedInstances,
        lastDeleted,
      ];

  HistoryState copyWith({
    LoadingStatus? activitiesLoadingStatus,
    LoadingStatus? logsLoadingStatus,
    List<Activity>? activities,
    List<ActivityInstance>? instances,
    Exception? exception,
    List<ActivityInstance>? selectedInstances,
    List<ActivityInstance>? lastDeleted,
  }) {
    // invalidating sorted cache if the original list changes
    if (instances != null) _sortedInstances = null;

    return HistoryState._(
      activitiesLoadingStatus:
          activitiesLoadingStatus ?? _activitiesLoadingStatus,
      logsLoadingStatus: logsLoadingStatus ?? _logsLoadingStatus,
      activities: activities != null
          ? HashMap.fromEntries(activities.map((e) => MapEntry(e.id, e)))
          : _activities,
      instances: instances ?? _instances,
      exception: LoadingStatusMixer.mix([
                activitiesLoadingStatus ?? _activitiesLoadingStatus,
                logsLoadingStatus ?? _logsLoadingStatus
              ]) !=
              LoadingStatus.error
          ? null
          : (exception ?? this.exception),
      selectedInstances: selectedInstances ?? this.selectedInstances,
      lastDeleted: lastDeleted ?? this.lastDeleted,
    );
  }

  LoadingStatus get loadingStatus =>
      LoadingStatusMixer.mix([_activitiesLoadingStatus, _logsLoadingStatus]);

  List<ActivityInstance>? _sortedInstances;
  List<ActivityInstance> get instances {
    if (_sortedInstances != null) return _sortedInstances!;
    _sortedInstances = [..._instances];
    _sortedInstances!.sort(
      (a, b) => -1 * a.startAt.compareTo(b.startAt),
    );
    return _sortedInstances!;
  }

  Activity? Function(ActivityInstance) get activityForInstance =>
      (ActivityInstance instance) => _activities[instance.activityId];
}
