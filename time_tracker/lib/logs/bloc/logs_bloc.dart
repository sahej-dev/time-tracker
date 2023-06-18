import 'dart:collection';

import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instances_repository/instances_repository.dart';

import '../../types.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc(
      {required ActivitiesRepository activitiesRepository,
      required InstancesRepository instancesRepository})
      : _activitiesRepository = activitiesRepository,
        _instancesRepository = instancesRepository,
        super(LogsState.initial()) {
    on<LogsActivitiesSubscriptionRequested>(_onActivitiesSubscriptionRequested);
    on<LogsSubscriptionRequested>(_onLogsSubscriptionRequested);
    on<LogsInstanceAdded>(_onInstanceAdded);
    on<LogsInstanceStopped>(_onInstanceStopped);
    on<LogsInstanceEdited>(_onInstanceEdit);
    on<LogsInstanceDeleted>(_onInstanceDeleted);
    on<LogsTryUndoLastDeleted>(_onLastDeletedUndoRequested);
  }

  final InstancesRepository _instancesRepository;
  final ActivitiesRepository _activitiesRepository;

  Future<void> _onActivitiesSubscriptionRequested(
    LogsActivitiesSubscriptionRequested event,
    Emitter<LogsState> emit,
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
    LogsSubscriptionRequested event,
    Emitter<LogsState> emit,
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

  Future<void> _onInstanceAdded(
    LogsInstanceAdded event,
    Emitter<LogsState> emit,
  ) async {
    int runningInstanceIdx =
        state.instances.indexWhere((instance) => instance.endAt == null);
    if (event.instance.endAt == null && runningInstanceIdx >= 0) {
      // closing last running instance (if any) at start time of current instance
      // if current instance is a running instance

      ActivityInstance instanceToBeEnded = state.instances[runningInstanceIdx];
      await _instancesRepository.editInstance(
        instance: instanceToBeEnded.copyWith(endAt: event.instance.startAt),
      );
    }

    // finally creating new instance
    _instancesRepository.createInstance(instance: event.instance);
  }

  Future<void> _onInstanceStopped(
    LogsInstanceStopped event,
    Emitter<LogsState> emit,
  ) async {
    ActivityInstance? instance = state.runningInstance;
    if (instance == null) return;

    _instancesRepository.editInstance(
        instance: instance.copyWith(endAt: event.stopTime.toLocal()));
  }

  Future<void> _onInstanceEdit(
    LogsInstanceEdited event,
    Emitter<LogsState> emit,
  ) async {
    _instancesRepository.editInstance(instance: event.instance);
  }

  Future<void> _onInstanceDeleted(
    LogsInstanceDeleted event,
    Emitter<LogsState> emit,
  ) async {
    emit(state.copyWith(lastDeleted: event.instance));

    _instancesRepository.deleteInstance(instance: event.instance);
  }

  Future<void> _onLastDeletedUndoRequested(
    LogsTryUndoLastDeleted event,
    Emitter<LogsState> emit,
  ) async {
    if (state.lastDeleted == null) return;
    if (state.instances.contains(state.lastDeleted)) {
      emit(state.copyWith(lastDeleted: null));
      return;
    }

    _instancesRepository.restoreInstance(instance: state.lastDeleted!);
  }
}
