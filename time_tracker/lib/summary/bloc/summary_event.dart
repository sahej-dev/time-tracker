part of 'summary_bloc.dart';

@immutable
abstract class SummaryEvent extends Equatable {
  const SummaryEvent();
}

class SummaryActivitiesSubscriptionRequested extends SummaryEvent {
  const SummaryActivitiesSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

class SummaryLogsSubscriptionRequested extends SummaryEvent {
  const SummaryLogsSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

class SummaryIntervalChangeRequested extends SummaryEvent {
  const SummaryIntervalChangeRequested({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

class SummaryToggleUntrackedVisibility extends SummaryEvent {
  const SummaryToggleUntrackedVisibility();

  @override
  List<Object?> get props => [];
}
