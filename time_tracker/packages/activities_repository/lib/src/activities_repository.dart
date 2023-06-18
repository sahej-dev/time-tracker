// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

import 'models/models.dart';

class ActivitiesRepository {
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

  final String apiUrl;
  FlutterSecureStorage _secureStorage;

  ActivitiesRepository({
    required FlutterSecureStorage secureStorage,
    required String userId,
    required this.apiUrl,
  }) : _secureStorage = secureStorage {
    _init(userId: userId);
  }

  void _init({required String userId}) async {
    final dio = await _dio;
    try {
      final Response response = await dio.get("/", queryParameters: {
        "by_user": userId,
      });

      final rawActivitiesList = response.data as List<dynamic>;
      final List<Activity> activities = [];

      for (int i = 0; i < rawActivitiesList.length; i++) {
        activities.add(Activity.fromJson(rawActivitiesList[i]));
      }

      _activityStreamController.add(activities);
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _activityStreamController.addError(
            "Unable to connect. Please check your network connection.");
      } else {
        _activityStreamController.addError(error);
      }
    }
  }

  Stream<List<Activity>> getActivites() =>
      _activityStreamController.asBroadcastStream();

  Future<void> postActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];
    final List<Activity> revertActivities = [
      ..._activityStreamController.value
    ];

    activities.add(activity);
    _activityStreamController.add(activities);

    final dio = await _dio;

    try {
      final Response response = await dio.post(
        "/",
        data: {
          "label": activity.label,
          "color": activity.color,
          "icon_codepoint": activity.icon.codepoint,
          "icon_family": activity.icon.metadata.fontFamily,
          "icon_package": activity.icon.metadata.fontPackage,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final Activity postedActivity = Activity.fromJson(response.data);
        revertActivities.add(postedActivity);
        _activityStreamController.add(revertActivities);
      } else {
        _activityStreamController.add(revertActivities);
        throw Exception("error posting activity");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _activityStreamController.addError(
            "Unable to connect. Please check your network connection.");
      } else {
        _activityStreamController.addError(error);
      }
    }
  }

  Future<void> editActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];
    final List<Activity> revertActivities = [
      ..._activityStreamController.value
    ];

    int idx = activities.indexWhere((ele) => ele.id == activity.id);
    if (idx < 0) return;
    activities[idx] = activity;
    _activityStreamController.add(activities);

    final dio = await _dio;

    try {
      final Response response = await dio.put(
        "/${activity.id}",
        data: {
          "label": activity.label,
          "color": activity.color,
          "icon_codepoint": activity.icon.codepoint,
          "icon_family": activity.icon.metadata.fontFamily,
          "icon_package": activity.icon.metadata.fontPackage,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final Activity editedActivity = Activity.fromJson(response.data);
        revertActivities[idx] = editedActivity;
        _activityStreamController.add(revertActivities);
      } else {
        _activityStreamController.add(revertActivities);
        throw Exception("Could not edit activity");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _activityStreamController.addError(
            "Unable to connect. Please check your network connection.");
      } else {
        _activityStreamController.addError(error);
      }
    }
  }

  Future<void> deleteActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];
    final List<Activity> revertActivities = [
      ..._activityStreamController.value
    ];

    int idx = activities.indexWhere((ele) => ele.id == activity.id);
    if (idx < 0) return;
    activities.removeAt(idx);
    _activityStreamController.add(activities);

    final dio = await _dio;

    try {
      final Response response = await dio.delete("/${activity.id}");

      if (response.statusCode != 200) {
        _activityStreamController.add(revertActivities);
        throw Exception("Could not delete activity");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _activityStreamController.addError(
            "Unable to connect. Please check your network connection.");
      } else {
        _activityStreamController.addError(error);
      }
    }
  }

  Future<void> restoreActivity({required Activity activity}) async {
    final List<Activity> activities = [..._activityStreamController.value];
    final List<Activity> revertActivities = [
      ..._activityStreamController.value
    ];

    activities.add(activity);
    _activityStreamController.add(activities);

    final dio = await _dio;

    try {
      final Response response = await dio.patch("/${activity.id}");

      if (response.statusCode == 200) {
        final Activity restoredActivity = Activity.fromJson(response.data);
        revertActivities.add(restoredActivity);

        _activityStreamController.add(revertActivities);
      } else {
        _activityStreamController.add(revertActivities);
        throw Exception("Could not restore activity");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _activityStreamController.addError(
            "Unable to connect. Please check your network connection.");
      } else {
        _activityStreamController.addError(error);
      }
    }
  }
}
