import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:activities_repository/activities_repository.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc({required ActivitiesRepository activitiesRepository})
      : _activitiesRepository = activitiesRepository,
        super(const ActivitiesState.initial()) {
    on<ActivitiesFetchRequested>(_onActivitesFetchRequested);
    on<ActivitiesNewAdded>(_onNewActivityAdded);
    on<ActivitiesEdited>(_onActivityEdited);
    on<ActivitiesDeleted>(_onActivityDeleteRequested);
    on<ActivitiesTryUndoLastDeleted>(_onLastDeletedUndoRequested);
  }

  final ActivitiesRepository _activitiesRepository;

  void _onActivitesFetchRequested(
      ActivitiesFetchRequested event, Emitter<ActivitiesState> emit) async {
    if (state.activities.isEmpty) {
      emit(state.copyWith(loadingStatus: LoadingStatus.pending));
    }

    try {
      final List<Activity>? activities =
          await _activitiesRepository.getActivities(
        userId: event.userId,
        force: event.force,
      );

      if (activities != null) {
        emit(state.copyWith(
          activities: activities,
          loadingStatus: LoadingStatus.success,
        ));
      } else {
        throw Exception("unable to fetch activities");
      }
    } catch (e) {
      print("activities fetch error::::");
      print(e);
      emit(state.copyWith(loadingStatus: LoadingStatus.error));
    }
  }

  void _onNewActivityAdded(
      ActivitiesNewAdded event, Emitter<ActivitiesState> emit) async {
    final List<Activity> revertActivities = [...state.activities];

    final List<Activity> newActivities = [...state.activities];
    newActivities.add(event.activity);

    emit(state.copyWith(activities: newActivities));

    try {
      Activity? postedActivity;

      if (event.activity.icon.id != '') {
        postedActivity = await _activitiesRepository.postActivity(
            label: event.activity.label,
            color: event.activity.color,
            iconId: event.activity.icon.id);
      } else {
        postedActivity = await _activitiesRepository.postActivity(
          label: event.activity.label,
          color: event.activity.color,
          iconCodepoint: event.activity.icon.codepoint,
          iconFamily: event.activity.icon.metadata.fontFamily,
          iconPackage: event.activity.icon.metadata.fontPackage,
        );
      }

      print(postedActivity);
      if (postedActivity == null) {
        throw Exception('Null postedActivity found exception');
      }

      revertActivities.add(postedActivity);
      print('emiting new state');
      emit(state.copyWith(activities: [...revertActivities]));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(activities: revertActivities));
    }
  }

  void _onActivityEdited(
      ActivitiesEdited event, Emitter<ActivitiesState> emit) async {
    final List<Activity> revertActivites = [...state.activities];

    final List<Activity> newActivities = [...state.activities];

    final int changedActivityIdx = newActivities
        .indexWhere((activity) => activity.id == event.activity.id);

    if (changedActivityIdx == -1) return;

    // optimistically updating with edited activity
    newActivities.removeAt(changedActivityIdx);
    newActivities.insert(changedActivityIdx, event.activity);
    emit(state.copyWith(activities: newActivities));

    try {
      await _activitiesRepository.editActivity(activity: event.activity);
    } catch (e) {
      print("error editing activity");
      print(e);

      emit(state.copyWith(activities: revertActivites));
    }
  }

  void _onActivityDeleteRequested(
      ActivitiesDeleted event, Emitter<ActivitiesState> emit) async {
    final List<Activity> revertActivities = [...state.activities];

    List<Activity> newActivities = [...state.activities];
    newActivities.remove(event.activity);

    emit(state.copyWith(
      activities: newActivities,
      lastDeleted: event.activity,
    ));

    try {
      await _activitiesRepository.deleteActivity(activityId: event.activity.id);
    } catch (e) {
      print("error in deleting activity");
      print(e);

      emit(state.copyWith(activities: revertActivities, lastDeleted: null));
    }
  }

  void _onLastDeletedUndoRequested(
      ActivitiesTryUndoLastDeleted event, Emitter<ActivitiesState> emit) async {
    print('lst deleted is: ${state.lastDeleted}');
    if (state.lastDeleted == null) return;
    if (state.activities.contains(state.lastDeleted)) {
      emit(state.copyWith(lastDeleted: null));
      return;
    }

    final List<Activity> revertActivities = [...state.activities];

    List<Activity> newActivities = [...state.activities];
    newActivities.add(state.lastDeleted!);
    emit(state.copyWith(activities: newActivities, lastDeleted: null));

    try {
      await _activitiesRepository.restoreActivity(
          activityId: state.lastDeleted!.id);
    } catch (e) {
      print("error in restoring last deleted activity");
      print(e);

      emit(state.copyWith(activities: revertActivities));
    }
  }
}
