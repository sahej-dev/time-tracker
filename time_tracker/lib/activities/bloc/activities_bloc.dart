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
  }

  final ActivitiesRepository _activitiesRepository;

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
      if (postedActivity == null) throw Exception('Null posted exception');

      newActivities.removeLast();
      newActivities.add(postedActivity);
      emit(ActivitiesState(activities: [...newActivities]));
    } catch (e) {
      print(e.toString());
      emit(ActivitiesState(activities: revertActivities));
    }
  }
}
