// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'instances_event_handler.dart';
import 'models/models.dart';

class RealtimeInstancesRepository {
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
  IO.Socket _socket;

  // ignore: unused_field
  late final InstancesEventHandler _instancesEventHandler;

  RealtimeInstancesRepository({
    required FlutterSecureStorage secureStorage,
    required this.apiUrl,
    required IO.Socket socket,
  })  : _secureStorage = secureStorage,
        _socket = socket {
    _init();
  }

  void _init() async {
    _socket.emitWithAck("instance:read_all", null, ack: (response) {
      final rawInstancesList = response as List<dynamic>;
      final List<ActivityInstance> instances = [];

      for (int i = 0; i < rawInstancesList.length; i++) {
        instances.add(NetworkActivityInstance.fromJson(rawInstancesList[i])
            .asExternalInstance());
      }
      _instancesStreamController.add(instances);
    });

    _instancesEventHandler = InstancesEventHandler(
      socket: _socket,
      instancesStreamController: _instancesStreamController,
    );
  }

  Stream<List<ActivityInstance>> getInstances() =>
      _instancesStreamController.asBroadcastStream();

  Future<void> createInstance({required ActivityInstance instance}) async {
    _socket.emit("instance:create", instance.asNetworkInstance().toJson());
  }

  Future<void> editInstance({required ActivityInstance instance}) async {
    _socket.emit("instance:edit", instance.asNetworkInstance().toJson());
  }

  Future<void> deleteInstance({required ActivityInstance instance}) async {
    _socket.emit("instance:delete", instance.id);
  }

  Future<void> restoreInstance({required ActivityInstance instance}) async {
    _socket.emit("instance:restore", instance.asNetworkInstance().toJson());
  }

  Future<void> deleteMultipleInstances({
    required List<ActivityInstance> instances,
  }) async {
    _socket.emit("instance:delete_multiple", {
      "ids": instances.map((e) => e.id).toList(),
    });
  }

  Future<void> restoreMultipleInstance({
    required List<ActivityInstance> instances,
  }) async {
    _socket.emit("instance:restore_multiple", {
      "ids": instances.map((e) => e.id).toList(),
    });
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
