part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {}

class ActivitiesNewAdded extends ActivitiesEvent {
  final Activity activity;

  ActivitiesNewAdded({required this.activity});

  @override
  List<Object?> get props => [activity];
}
