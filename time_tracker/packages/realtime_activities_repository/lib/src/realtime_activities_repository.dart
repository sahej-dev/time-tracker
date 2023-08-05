// ignore_for_file: deprecated_member_use
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'activities_event_handler.dart';
import 'models/models.dart';
import 'models/network_activity.dart';

class RealtimeActivitiesRepository {
  final _activityStreamController = BehaviorSubject<List<Activity>>();

  Dio? __dio;

  Future<Dio> get _dio async {
    if (__dio != null) {
      return __dio!;
    }

    final String? token = await _secureStorage.read(key: "token");

    if (token == null) {
      throw Exception("jwt not present in secure storage");
    }

    __dio = Dio(BaseOptions(
      baseUrl: "${apiUrl}/api/v1/activities",
      headers: {"authorization": "Bearer ${token}"},
      sendTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ));

    return __dio!;
  }

  FlutterSecureStorage _secureStorage;

  IO.Socket _socket;
  final String apiUrl;

  // ignore: unused_field
  late final ActivitiesEventHandler _activitiesEventHandler;

  RealtimeActivitiesRepository({
    required FlutterSecureStorage secureStorage,
    required this.apiUrl,
    required IO.Socket socket,
  })  : _socket = socket,
        _secureStorage = secureStorage {
    _init();
    _activitiesEventHandler = ActivitiesEventHandler(
      socket: socket,
      activityStreamController: _activityStreamController,
    );
  }

  void _init() async {
    _socket.emitWithAck('activity:read_all', null, ack: (response) {
      final rawActivitiesList = response as List<dynamic>;
      final List<Activity> activities = [];

      for (int i = 0; i < rawActivitiesList.length; i++) {
        activities.add(NetworkActivity.fromJson(rawActivitiesList[i])
            .asExternalActivity());
      }

      _activityStreamController.add(activities);
    });
  }

  Stream<List<Activity>> getActivites() =>
      _activityStreamController.asBroadcastStream();

  Future<void> postActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];

    activities.add(activity);
    _activityStreamController.add(activities);

    _socket.emit("activity:create", {
      "id": activity.id,
      "label": activity.label,
      "color": activity.color?.value,
      "icon_codepoint": activity.iconData.codePoint,
      "icon_family": activity.iconData.fontFamily,
      "icon_package": activity.iconData.fontPackage,
      "createdAt": activity.createdAt.toIso8601String(),
    });
  }

  Future<void> editActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];

    int idx = activities.indexWhere((ele) => ele.id == activity.id);
    if (idx < 0) return;
    activities[idx] = activity;
    _activityStreamController.add(activities);

    _socket.emit(
      "activity:edit",
      {
        "id": activity.id,
        "label": activity.label,
        "color": activity.color?.value,
        "icon_codepoint": activity.iconData.codePoint,
        "icon_family": activity.iconData.fontFamily,
        "icon_package": activity.iconData.fontPackage,
        "updatedAt": DateTime.now().toIso8601String()
      },
    );
  }

  Future<void> deleteActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];

    int idx = activities.indexWhere((ele) => ele.id == activity.id);
    if (idx < 0) return;
    activities.removeAt(idx);
    _activityStreamController.add(activities);

    _socket.emit("activity:delete", {"id": activity.id});
  }

  Future<void> restoreActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];

    activities.add(activity);
    _activityStreamController.add(activities);

    _socket.emit("activity:restore", {
      "id": activity.id,
    });
  }
}
