import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instances_repository/instances_repository.dart';

import '../../types.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc({required InstancesRepository instancesRepository})
      : _instancesRepository = instancesRepository,
        super(const LogsState.initial()) {
    on<LogsSubscriptionRequested>(_onSubscriptionRequested);
    on<LogsInstanceAdded>(_onInstanceAdded);
    on<LogsInstanceStopped>(_onInstanceStopped);
    on<LogsInstanceEdited>(_onInstanceEdit);
    on<LogsInstanceDeleted>(_onInstanceDeleted);
    on<LogsTryUndoLastDeleted>(_onLastDeletedUndoRequested);
  }

  final InstancesRepository _instancesRepository;

  Future<void> _onSubscriptionRequested(
    LogsSubscriptionRequested event,
    Emitter<LogsState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.pending));

    await emit.forEach<List<ActivityInstance>>(
      _instancesRepository.getInstances(),
      onData: (instances) {
        return state.copyWith(
          loadingStatus: LoadingStatus.success,
          instances: instances,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          loadingStatus: LoadingStatus.error,
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
        instance: instance.copyWith(endAt: event.stopTime));
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
