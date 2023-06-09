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
}
