part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class HistoryActivitiesSubscriptionsRequested extends HistoryEvent {
  const HistoryActivitiesSubscriptionsRequested();

  @override
  List<Object?> get props => [];
}

class HistoryLogsSubscriptionsRequested extends HistoryEvent {
  const HistoryLogsSubscriptionsRequested();

  @override
  List<Object?> get props => [];
}
