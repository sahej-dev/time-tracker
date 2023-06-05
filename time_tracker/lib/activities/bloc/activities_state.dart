part of 'activities_bloc.dart';

enum ActivitiesSyncStatus { unsynced, synced, syncing }

enum LoadingStatus { initial, pending, success, error }

class ActivitiesState extends Equatable {
  final List<Activity> activities;
  final LoadingStatus loadingStatus;

  const ActivitiesState({
    this.activities = const [],
    this.loadingStatus = LoadingStatus.initial,
  });

  ActivitiesState copyWith({
    List<Activity>? activities,
    LoadingStatus? loadingStatus,
  }) {
    return ActivitiesState(
      activities: activities ?? this.activities,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object?> get props => [activities, loadingStatus];
}
