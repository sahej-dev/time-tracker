import 'dart:collection';

import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instances_repository/instances_repository.dart';
import 'package:meta/meta.dart';

import '../../types.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  SummaryBloc(
      {required ActivitiesRepository activitiesRepository,
      required InstancesRepository instancesRepository})
      : _activitiesRepository = activitiesRepository,
        _instancesRepository = instancesRepository,
        super(SummaryState.initial()) {
    on<SummaryActivitiesSubscriptionRequested>(
        _onActivitiesSubscriptionRequested);
    on<SummaryLogsSubscriptionRequested>(_onLogsSubscriptionRequested);
  }

  final InstancesRepository _instancesRepository;
  final ActivitiesRepository _activitiesRepository;

  Future<void> _onActivitiesSubscriptionRequested(
    SummaryActivitiesSubscriptionRequested event,
    Emitter<SummaryState> emit,
  ) async {
    emit(state.copyWith(
      activitiesLoadingStatus: LoadingStatus.pending,
    ));

    await emit.forEach<List<Activity>>(
      _activitiesRepository.getActivites(),
      onData: (activities) {
        return state.copyWith(
          activitiesLoadingStatus: LoadingStatus.success,
          activities: activities,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          activitiesLoadingStatus: LoadingStatus.error,
          exception: Exception(error.toString()),
        );
      },
    );
  }

  Future<void> _onLogsSubscriptionRequested(
    SummaryLogsSubscriptionRequested event,
    Emitter<SummaryState> emit,
  ) async {
    emit(state.copyWith(
      logsLoadingStatus: LoadingStatus.pending,
    ));

    await emit.forEach<List<ActivityInstance>>(
      _instancesRepository.getInstances(),
      onData: (instances) {
        return state.copyWith(
          logsLoadingStatus: LoadingStatus.success,
          instances: instances,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          logsLoadingStatus: LoadingStatus.error,
          exception: Exception(error.toString()),
        );
      },
    );
  }
}
