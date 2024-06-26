import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:realtime_activities_repository/realtime_activities_repository.dart';

import '../../types.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc({required RealtimeActivitiesRepository activitiesRepository})
      : _activitiesRepository = activitiesRepository,
        super(const ActivitiesState.initial()) {
    on<ActivitiesSubscriptionRequested>(_onSubscriptionRequested);
    on<ActivitiesNewAdded>(_onNewActivityAdded);
    on<ActivitiesEdited>(_onActivityEdited);
    on<ActivitiesDeleted>(_onActivityDeleteRequested);
    on<ActivitiesTryUndoLastDeleted>(_onLastDeletedUndoRequested);
  }

  final RealtimeActivitiesRepository _activitiesRepository;

  Future<void> _onSubscriptionRequested(
    ActivitiesSubscriptionRequested event,
    Emitter<ActivitiesState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.pending));

    await emit.forEach<List<Activity>>(
      _activitiesRepository.getActivites(),
      onData: (activities) {
        return state.copyWith(
          loadingStatus: LoadingStatus.success,
          activities: activities,
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

  void _onNewActivityAdded(
      ActivitiesNewAdded event, Emitter<ActivitiesState> emit) async {
    await _activitiesRepository.postActivity(activity: event.activity);
  }

  void _onActivityEdited(
      ActivitiesEdited event, Emitter<ActivitiesState> emit) async {
    await _activitiesRepository.editActivity(activity: event.activity);
  }

  void _onActivityDeleteRequested(
      ActivitiesDeleted event, Emitter<ActivitiesState> emit) async {
    emit(state.copyWith(lastDeleted: event.activity));
    await _activitiesRepository.deleteActivity(activity: event.activity);
  }

  void _onLastDeletedUndoRequested(
      ActivitiesTryUndoLastDeleted event, Emitter<ActivitiesState> emit) async {
    if (state.lastDeleted == null) return;
    if (state.activities.contains(state.lastDeleted)) {
      emit(state.copyWith(lastDeleted: null));
      return;
    }
    _activitiesRepository.restoreActivity(activity: state.lastDeleted!);
  }
}
