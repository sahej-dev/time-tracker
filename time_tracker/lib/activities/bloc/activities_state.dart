part of 'activities_bloc.dart';

enum ActivitiesSyncStatus { unsynced, synced, syncing }

enum LoadingStatus { initial, pending, success, error }

enum SortBy { createdAt, name }

class ActivitiesState extends Equatable {
  final List<Activity> activities;
  final LoadingStatus loadingStatus;
  final Activity? lastDeleted;
  final List<Activity>? sortedActivities;

  const ActivitiesState._({
    this.activities = const [],
    this.loadingStatus = LoadingStatus.initial,
    this.sortedActivities,
    this.lastDeleted,
  });

  const ActivitiesState.initial() : this._();

  ActivitiesState copyWith({
    List<Activity>? activities,
    LoadingStatus? loadingStatus,
    Activity? lastDeleted,
  }) {
    return ActivitiesState._(
      activities: activities ?? this.activities,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      lastDeleted: lastDeleted ?? this.lastDeleted,
    );
  }

  @override
  List<Object?> get props => [activities, loadingStatus];
}
