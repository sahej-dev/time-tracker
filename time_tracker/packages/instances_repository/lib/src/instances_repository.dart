// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class InstancesRepository {
  final _instancesStreamController = BehaviorSubject<List<ActivityInstance>>();

  List<ActivityInstance> _locallyDeletedInstances = [];

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
      baseUrl: "${apiUrl}/api/v1",
      headers: {"authorization": "Bearer ${token}"},
      sendTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ));

    return __dio!;
  }

  FlutterSecureStorage _secureStorage;
  final String apiUrl;

  InstancesRepository({
    required FlutterSecureStorage secureStorage,
    required this.apiUrl,
  }) : _secureStorage = secureStorage {
    _init();
  }

  void _init() async {
    final dio = await _dio;

    try {
      final Response response = await dio.get("/instances");

      final rawInstancesList = response.data as List<dynamic>;
      final List<ActivityInstance> instances = [];

      for (int i = 0; i < rawInstancesList.length; i++) {
        instances.add(ActivityInstance.fromJson(rawInstancesList[i]));
      }
      _instancesStreamController.add(instances);
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  Stream<List<ActivityInstance>> getInstances() =>
      _instancesStreamController.asBroadcastStream();

  Future<void> createInstance({required ActivityInstance instance}) async {
    final List<ActivityInstance> revertInstances = [
      ..._instancesStreamController.value
    ];
    final List<ActivityInstance> newInstances = [
      ..._instancesStreamController.value
    ];

    newInstances.add(instance);

    final dio = await _dio;

    try {
      final Response response = await dio.post(
        "/activities/${instance.activityId}/instances",
        data: instance.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final ActivityInstance createdInstance =
            ActivityInstance.fromJson(response.data);

        revertInstances.add(createdInstance);
        _instancesStreamController.add(revertInstances);
      } else {
        _instancesStreamController.add(revertInstances);
        throw Exception("error posting activity instance");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  Future<void> editInstance({required ActivityInstance instance}) async {
    final List<ActivityInstance> revertInstances = [
      ..._instancesStreamController.value
    ];
    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    int idx = instances.indexWhere((ele) => ele.id == instance.id);
    if (idx < 0) return;
    instances[idx] = instance;
    _instancesStreamController.add(instances);

    final dio = await _dio;

    try {
      final Response response = await dio.put(
        "/instances/${instance.id}",
        data: instance.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final ActivityInstance editedInstance =
            ActivityInstance.fromJson(response.data);

        revertInstances[idx] = editedInstance;
        _instancesStreamController.add(revertInstances);
      } else {
        _instancesStreamController.add(revertInstances);
        throw Exception("error editing activity instance");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  Future<void> deleteInstance({required ActivityInstance instance}) async {
    final List<ActivityInstance> revertInstances = [
      ..._instancesStreamController.value
    ];
    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    int idx = instances.indexWhere((ele) => ele.id == instance.id);
    if (idx < 0) return;
    instances.removeAt(idx);
    _instancesStreamController.add(instances);

    final dio = await _dio;

    try {
      final Response response = await dio.delete(
        "/instances/${instance.id}",
      );

      if (response.statusCode != 200) {
        _instancesStreamController.add(revertInstances);
        throw Exception("error deleting activity instance");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  Future<void> restoreInstance({required ActivityInstance instance}) async {
    final List<ActivityInstance> revertInstances = [
      ..._instancesStreamController.value
    ];
    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    instances.add(instance);
    _instancesStreamController.add(instances);

    final dio = await _dio;

    try {
      final Response response = await dio.patch(
        "/instances/${instance.id}",
      );

      if (response.statusCode == 200) {
        final ActivityInstance restoredInstance =
            ActivityInstance.fromJson(response.data);
        revertInstances.add(restoredInstance);

        _instancesStreamController.add(revertInstances);
      } else {
        _instancesStreamController.add(revertInstances);
        throw Exception("error restoring activity instance");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  Future<void> deleteMultipleInstances(
      {required List<ActivityInstance> instances}) async {
    final List<ActivityInstance> revertInstances = [
      ..._instancesStreamController.value
    ];
    final List<ActivityInstance> newInstances = [
      ..._instancesStreamController.value
    ];

    newInstances.removeWhere((instance) => instances.contains(instance));
    _instancesStreamController.add(newInstances);

    final dio = await _dio;

    try {
      final Response response = await dio.delete(
        "/instances",
        data: {
          "ids": instances.map((e) => e.id).toList(),
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        _instancesStreamController.add(revertInstances);
        throw Exception("error deleting multiple activity instances");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  Future<void> restoreMultipleInstance(
      {required List<ActivityInstance> instances}) async {
    final List<ActivityInstance> revertInstances = [
      ..._instancesStreamController.value
    ];
    final List<ActivityInstance> newInstances = [
      ..._instancesStreamController.value
    ];

    instances.removeWhere((instance) => revertInstances.contains(instance));

    newInstances.addAll(instances);
    _instancesStreamController.add(newInstances);

    final dio = await _dio;

    try {
      final Response response = await dio.patch(
        "/instances",
        data: {
          "ids": instances.map((e) => e.id).toList(),
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final rawInstancesList = response.data as List<dynamic>;

        final List<ActivityInstance> restoredInstances = [];
        for (int i = 0; i < rawInstancesList.length; i++) {
          restoredInstances.add(ActivityInstance.fromJson(rawInstancesList[i]));
        }

        revertInstances.addAll(restoredInstances);
        _instancesStreamController.add(revertInstances);
      } else {
        _instancesStreamController.add(revertInstances);
        throw Exception("error restoring multiple activity instances");
      }
    } on DioError catch (error) {
      if ([
        DioErrorType.sendTimeout,
        DioErrorType.receiveTimeout,
        DioErrorType.connectionTimeout
      ].contains(error.type)) {
        _instancesStreamController.addError(Exception(
            "Unable to connect. Please check your network connection."));
      } else {
        _instancesStreamController.addError(error);
      }
    }
  }

  void locallyDeleteInstancesOfActivity(String activityId) {
    List<ActivityInstance> instances = [..._instancesStreamController.value];

    _locallyDeletedInstances.addAll(
      instances.where((instance) => instance.activityId == activityId),
    );

    instances.removeWhere((instance) => instance.activityId == activityId);

    _instancesStreamController.add(instances);
  }

  void restoreLocallyDeletedInstanceOfActivity(String activityId) {
    if (_locallyDeletedInstances.isEmpty ||
        _locallyDeletedInstances
                .indexWhere((instance) => instance.activityId == activityId) <
            0) return;

    List<ActivityInstance> instances = [..._instancesStreamController.value];

    instances.addAll(
      _locallyDeletedInstances
          .where((instance) => instance.activityId == activityId),
    );

    _locallyDeletedInstances.removeWhere(
      (instance) => instance.activityId == activityId,
    );

    _instancesStreamController.add(instances);
  }
}
