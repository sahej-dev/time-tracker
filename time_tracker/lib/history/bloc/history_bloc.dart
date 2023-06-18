import 'dart:collection';

import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instances_repository/instances_repository.dart';
import 'package:moment_dart/moment_dart.dart';

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
    on<HistoryInstanceSelected>(_onInstanceSelected);
    on<HistorySelectAllOnDate>(_onSelectAllOnDate);
    on<HistoryUnselectAllOnDate>(_onUnselectAllOnDate);
    on<HistoryInstanceUnselected>(_onInstanceUnselected);
    on<HistoryUnselectAll>(_onUnselectAll);
    on<HistoryDeleteSelected>(_onDeleteSelected);
    on<HistoryTryUndoLastDeleted>(_onTryUndoLastDelted);
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

  Future<void> _onInstanceSelected(
    HistoryInstanceSelected event,
    Emitter<HistoryState> emit,
  ) async {
    if (state.selectedInstances.contains(event.instance)) return;

    emit(state.copyWith(
      selectedInstances: [...state.selectedInstances, event.instance],
    ));
  }

  Future<void> _onSelectAllOnDate(
    HistorySelectAllOnDate event,
    Emitter<HistoryState> emit,
  ) async {
    List<ActivityInstance> newSelection = state.instances
        .where((instance) => instance.startAt
            .toMoment()
            .toLocal()
            .isAtSameDayAs(event.dateTime.toMoment().toLocal()))
        .toList();

    emit(state.copyWith(
        selectedInstances: [...state.selectedInstances, ...newSelection]));
  }

  Future<void> _onUnselectAllOnDate(
    HistoryUnselectAllOnDate event,
    Emitter<HistoryState> emit,
  ) async {
    List<ActivityInstance> selection = [...state.selectedInstances];

    selection.removeWhere((instance) => instance.startAt
        .toMoment()
        .toLocal()
        .isAtSameDayAs(event.dateTime.toMoment().toLocal()));

    emit(state.copyWith(selectedInstances: selection));
  }

  Future<void> _onInstanceUnselected(
    HistoryInstanceUnselected event,
    Emitter<HistoryState> emit,
  ) async {
    if (!state.selectedInstances.contains(event.instance)) return;

    List<ActivityInstance> newSelection = [...state.selectedInstances];
    newSelection.remove(event.instance);
    emit(state.copyWith(
      selectedInstances: newSelection,
    ));
  }

  Future<void> _onUnselectAll(
    HistoryUnselectAll event,
    Emitter<HistoryState> emit,
  ) async {
    if (state.selectedInstances.isEmpty) return;

    emit(state.copyWith(selectedInstances: []));
  }

  Future<void> _onDeleteSelected(
    HistoryDeleteSelected event,
    Emitter<HistoryState> emit,
  ) async {
    if (state.selectedInstances.isEmpty) return;

    final List<ActivityInstance> instancesToDelete = [
      ...state.selectedInstances
    ];

    emit(state.copyWith(
      lastDeleted: state.selectedInstances,
      selectedInstances: [],
    ));

    await _instancesRepository.deleteMultipleInstances(
      instances: instancesToDelete,
    );
  }

  Future<void> _onTryUndoLastDelted(
    HistoryTryUndoLastDeleted event,
    Emitter<HistoryState> emit,
  ) async {
    if (state.lastDeleted == null) return;

    List<ActivityInstance> instancesToRestore = [...state.lastDeleted!];
    instancesToRestore.removeWhere(
      (instance) => state.instances.contains(instance),
    );

    if (instancesToRestore.isEmpty) {
      emit(state.copyWith(lastDeleted: null));
      return;
    }

    await _instancesRepository.restoreMultipleInstance(
      instances: instancesToRestore,
    );
  }

  @override
  void onChange(Change<HistoryState> change) {
    super.onChange(change);

    final Iterable<String> currKeys = change.currentState._activities.keys;
    final Iterable<String> nextKeys = change.nextState._activities.keys;

    final bool isSomethingBeingDeleted = currKeys.length > nextKeys.length;
    final bool isSomethingBeingAdded = currKeys.length < nextKeys.length;

    if (isSomethingBeingDeleted) {
      final Iterable<String> keysBeingDeleted = currKeys.where(
        (currKey) => !nextKeys.contains(currKey),
      );

      for (String key in keysBeingDeleted) {
        _instancesRepository.locallyDeleteInstancesOfActivity(key);
      }
    } else if (isSomethingBeingAdded) {
      final Iterable<String> keysBeingAdded = nextKeys.where(
        (nextKey) => !currKeys.contains(nextKey),
      );

      for (String key in keysBeingAdded) {
        _instancesRepository.restoreLocallyDeletedInstanceOfActivity(key);
      }
    }
  }
}
