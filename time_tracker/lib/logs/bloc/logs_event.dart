part of 'logs_bloc.dart';

abstract class LogsEvent extends Equatable {
  const LogsEvent();
}

class LogsActivitiesSubscriptionRequested extends LogsEvent {
  const LogsActivitiesSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

class LogsSubscriptionRequested extends LogsEvent {
  const LogsSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

class LogsInstanceAdded extends LogsEvent {
  final ActivityInstance instance;

  const LogsInstanceAdded({required this.instance});
  @override
  List<Object?> get props => [instance];
}

class LogsInstanceStopped extends LogsEvent {
  final DateTime stopTime;

  const LogsInstanceStopped({required this.stopTime});

  @override
  List<Object?> get props => [stopTime];
}

class LogsInstanceEdited extends LogsEvent {
  final ActivityInstance instance;

  const LogsInstanceEdited({required this.instance});

  @override
  List<Object?> get props => [instance];
}

class LogsInstanceDeleted extends LogsEvent {
  final ActivityInstance instance;

  const LogsInstanceDeleted({required this.instance});

  @override
  List<Object?> get props => [instance];
}

class LogsTryUndoLastDeleted extends LogsEvent {
  const LogsTryUndoLastDeleted();

  @override
  List<Object?> get props => [];
}
