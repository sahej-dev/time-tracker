import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/models.dart';

class InstancesRepository {
  final _instancesStreamController =
      BehaviorSubject<List<ActivityInstance>>.seeded(const []);

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
      baseUrl: "http://10.0.2.2:2000/api/v1",
      headers: {"authorization": "Bearer ${token}"},
    ));

    return __dio!;
  }

  FlutterSecureStorage _secureStorage;

  InstancesRepository({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage {
    _init();
  }

  void _init() async {
    final dio = await _dio;

    final Response response = await dio.get("/instances");

    final rawInstancesList = response.data as List<dynamic>;
    final List<ActivityInstance> instances = [];

    for (int i = 0; i < rawInstancesList.length; i++) {
      instances.add(ActivityInstance.fromJson(rawInstancesList[i]));
    }

    _instancesStreamController.add(instances);
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

    final Response response = await dio.put(
      "/activities/${instance.activityId}/instances/${instance.id}",
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
  }
}
