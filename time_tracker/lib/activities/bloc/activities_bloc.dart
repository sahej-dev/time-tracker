import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:activities_repository/activities_repository.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc({required ActivitiesRepository activitiesRepository})
      : _activitiesRepository = activitiesRepository,
        super(const ActivitiesState()) {
    on<ActivitiesNewAdded>(_onNewActivityAdded);
    on<ActivitiesFetchRequested>(_onActivitesFetchRequested);
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

      newActivities.removeLast();
      newActivities.add(postedActivity);
      emit(state.copyWith(activities: [...newActivities]));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(activities: revertActivities));
    }
  }
}
