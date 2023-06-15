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

class HistoryInstanceSelected extends HistoryEvent {
  final ActivityInstance instance;

  const HistoryInstanceSelected({required this.instance});

  @override
  List<Object?> get props => [instance];
}

class HistorySelectAllOnDate extends HistoryEvent {
  final DateTime dateTime;

  const HistorySelectAllOnDate({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class HistoryUnselectAllOnDate extends HistoryEvent {
  final DateTime dateTime;

  const HistoryUnselectAllOnDate({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class HistoryInstanceUnselected extends HistoryEvent {
  final ActivityInstance instance;

  const HistoryInstanceUnselected({required this.instance});

  @override
  List<Object?> get props => [instance];
}

class HistoryUnselectAll extends HistoryEvent {
  const HistoryUnselectAll();

  @override
  List<Object?> get props => [];
}

class HistoryDeleteSelected extends HistoryEvent {
  const HistoryDeleteSelected();

  @override
  List<Object?> get props => [];
}

class HistoryTryUndoLastDeleted extends HistoryEvent {
  const HistoryTryUndoLastDeleted();

  @override
  List<Object?> get props => [];
}
