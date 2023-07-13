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
