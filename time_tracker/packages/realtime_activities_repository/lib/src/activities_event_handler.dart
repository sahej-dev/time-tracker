import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/models.dart';
import 'models/network_activity.dart';

class ActivitiesEventHandler {
  IO.Socket _socket;
  final BehaviorSubject<List<Activity>> _activityStreamController;

  ActivitiesEventHandler({
    required IO.Socket socket,
    required BehaviorSubject<List<Activity>> activityStreamController,
  })  : _socket = socket,
        _activityStreamController = activityStreamController {
    _socket.on("activity:create", _createServerActivity);
    _socket.on("activity:edit", _editServerActivity);
    _socket.on("activity:delete", _deleteServerActivity);
    _socket.on("activity:restore", _restoreServerActivity);
  }

  Future<void> _createServerActivity(data) async {
    final NetworkActivity networkActivity = NetworkActivity.fromJson(data);

    List<Activity> activities = [..._activityStreamController.value];
    activities.add(networkActivity.asExternalActivity());
    _activityStreamController.add(activities);
  }

  Future<void> _editServerActivity(data) async {
    final NetworkActivity networkActivity = NetworkActivity.fromJson(data);

    List<Activity> activities = [..._activityStreamController.value];

    int idx = activities.indexWhere((ele) => ele.id == networkActivity.id);
    if (idx < 0) return;

    activities[idx] = networkActivity.asExternalActivity();
    _activityStreamController.add(activities);
  }

  Future<void> _deleteServerActivity(data) async {
    final String deletedActivityId = data["id"];

    final List<Activity> activities = [..._activityStreamController.value];

    int idx = activities.indexWhere((ele) => ele.id == deletedActivityId);
    if (idx < 0) return;

    activities.removeAt(idx);
    _activityStreamController.add(activities);
  }

  Future<void> _restoreServerActivity(data) async {
    final NetworkActivity networkActivity = NetworkActivity.fromJson(data);

    final List<Activity> activities = [..._activityStreamController.value];

    activities.add(networkActivity.asExternalActivity());
    _activityStreamController.add(activities);
  }
}
