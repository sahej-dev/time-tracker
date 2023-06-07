part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();
}

class ActivitiesSubscriptionRequested extends ActivitiesEvent {
  const ActivitiesSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

class ActivitiesNewAdded extends ActivitiesEvent {
  final Activity activity;

  const ActivitiesNewAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class ActivitiesEdited extends ActivitiesEvent {
  final Activity activity;

  const ActivitiesEdited({required this.activity});

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
