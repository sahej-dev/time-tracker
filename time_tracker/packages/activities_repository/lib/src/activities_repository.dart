import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class ActivitiesRepository {
  List<Activity>? _activities;

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
      baseUrl: "http://10.0.2.2:2000/api/v1/activities",
      headers: {"authorization": "Bearer ${token}"},
    ));

    return __dio!;
  }

  FlutterSecureStorage _secureStorage;

  ActivitiesRepository({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<List<Activity>?> getActivities({
    required String userId,
    bool force = false,
  }) async {
    if (_activities != null) {
      return _activities;
    }

    final dio = await _dio;

    final Response response = await dio.get("/", queryParameters: {
      "by_user": userId,
    });

    final rawActivitiesList = response.data as List<dynamic>;
    _activities = [];

    for (int i = 0; i < rawActivitiesList.length; i++) {
      _activities!.add(Activity.fromJson(rawActivitiesList[i]));
    }

    return _activities;
  }

  Future<Activity?> postActivity({
    required String label,
    int? color,
    String? iconId,
    int? iconCodepoint,
    String? iconFamily,
    String? iconPackage,
  }) async {
    assert(iconId != null || iconCodepoint != null);
    assert(iconId == null || iconCodepoint == null);

    final dio = await _dio;

    final Response response = await dio.post(
      "/",
      data: {
        "label": label,
        "color": color,
        "icon_id": iconId,
        "icon_codepoint": iconCodepoint,
        "icon_family": iconFamily,
        "icon_package": iconPackage,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    return Activity.fromJson(response.data);
  }

  Future<void> deleteActivity({required String activityId}) async {
    final dio = await _dio;

    final Response response = await dio.delete("/${activityId}");

    if (response.statusCode != 200) {
      throw Exception("Could not delete activity");
    }
  }

  Future<void> restoreActivity({required String activityId}) async {
    final dio = await _dio;

    final Response response = await dio.patch("/${activityId}");

    if (response.statusCode != 200) {
      throw Exception("Could not restore activity");
    }
  }
}
