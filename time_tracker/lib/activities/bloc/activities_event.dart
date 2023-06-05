part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();
}

class ActivitiesFetchRequested extends ActivitiesEvent {
  final String userId;
  final bool force;
  const ActivitiesFetchRequested({required this.userId, this.force = false});

  @override
  List<Object?> get props => [force];
}

class ActivitiesNewAdded extends ActivitiesEvent {
  final Activity activity;

  const ActivitiesNewAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class ActivitiesDeleted extends ActivitiesEvent {
  final Activity activity;

  const ActivitiesDeleted({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class ActivitiesTryUndoLastDeleted extends ActivitiesEvent {
  const ActivitiesTryUndoLastDeleted();

  @override
  List<Object?> get props => [];
}
