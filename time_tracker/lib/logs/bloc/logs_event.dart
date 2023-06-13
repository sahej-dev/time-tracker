part of 'logs_bloc.dart';

abstract class LogsEvent extends Equatable {
  const LogsEvent();

  @override
  List<Object?> get props => [];
}

class LogsSubscriptionRequested extends LogsEvent {
  const LogsSubscriptionRequested();
}

class LogsInstanceAdded extends LogsEvent {
  final ActivityInstance instance;

  const LogsInstanceAdded({required this.instance});
}

class LogsInstanceStopped extends LogsEvent {
  final DateTime stopTime;

  const LogsInstanceStopped({required this.stopTime});
}

class LogsInstanceEdited extends LogsEvent {
  final ActivityInstance instance;

  const LogsInstanceEdited({required this.instance});
}

class LogsInstanceDeleted extends LogsEvent {
  final ActivityInstance instance;

  const LogsInstanceDeleted({required this.instance});
}
