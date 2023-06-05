part of 'activities_bloc.dart';

enum ActivitiesSyncStatus { unsynced, synced, syncing }

class ActivitiesState extends Equatable {
  final List<Activity> activities;

  const ActivitiesState({
    this.activities = const [],
  });

  ActivitiesState copyWith({
    List<Activity>? activities,
  }) {
    return ActivitiesState(
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [activities];
}
