part of 'activities_bloc.dart';

enum ActivitiesSyncStatus { unsynced, synced, syncing }

enum SortBy { createdAt, name }

class ActivitiesState extends Equatable {
  final List<Activity> activities;
  final LoadingStatus loadingStatus;
  final Activity? lastDeleted;
  final List<Activity>? sortedActivities;
  final Exception? exception;

  const ActivitiesState._({
    this.activities = const [],
    this.loadingStatus = LoadingStatus.initial,
    this.sortedActivities,
    this.lastDeleted,
    this.exception,
  });

  const ActivitiesState.initial() : this._();

  ActivitiesState copyWith({
    List<Activity>? activities,
    LoadingStatus? loadingStatus,
    Activity? lastDeleted,
    Exception? exception,
  }) {
    return ActivitiesState._(
      activities: activities ?? this.activities,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      lastDeleted: lastDeleted ?? this.lastDeleted,
      exception: (loadingStatus ?? this.loadingStatus) != LoadingStatus.error
          ? null
          : (exception ?? this.exception),
    );
  }

  @override
  List<Object?> get props => [activities, loadingStatus, lastDeleted];
}
