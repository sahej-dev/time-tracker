part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {}

class ActivitiesFetchRequested extends ActivitiesEvent {
  final String userId;
  final bool force;
  ActivitiesFetchRequested({required this.userId, this.force = false});

  @override
  List<Object?> get props => [force];
}

class ActivitiesNewAdded extends ActivitiesEvent {
  final Activity activity;

  ActivitiesNewAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}
