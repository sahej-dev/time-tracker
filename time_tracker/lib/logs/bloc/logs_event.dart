part of 'logs_bloc.dart';

abstract class LogsEvent extends Equatable {
  const LogsEvent();

  @override
  List<Object?> get props => [];
}

class LogsSubscriptionRequested extends LogsEvent {
  const LogsSubscriptionRequested();
}
