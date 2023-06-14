import 'dart:collection';

import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instances_repository/instances_repository.dart';

import '../../types.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ActivitiesRepository _activitiesRepository;
  final InstancesRepository _instancesRepository;

  HistoryBloc({
    required ActivitiesRepository activitiesRepository,
    required InstancesRepository instancesRepository,
  })  : _activitiesRepository = activitiesRepository,
        _instancesRepository = instancesRepository,
        super(HistoryState.initial()) {
    on<HistoryActivitiesSubscriptionsRequested>(
        _onActivitiesSubscriptionRequested);
    on<HistoryLogsSubscriptionsRequested>(_onLogsSubscriptionRequested);
  }

  Future<void> _onActivitiesSubscriptionRequested(
    HistoryActivitiesSubscriptionsRequested event,
    Emitter<HistoryState> emit,
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
    HistoryLogsSubscriptionsRequested event,
    Emitter<HistoryState> emit,
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
