import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/models.dart';

class InstancesEventHandler {
  IO.Socket _socket;
  final BehaviorSubject<List<ActivityInstance>> _instancesStreamController;

  InstancesEventHandler({
    required IO.Socket socket,
    required BehaviorSubject<List<ActivityInstance>> instancesStreamController,
  })  : _socket = socket,
        _instancesStreamController = instancesStreamController {
    _socket.on("instance:create", _createServerInstance);
    _socket.on("instance:edit", _editServerInstance);
    _socket.on("instance:delete", _deleteServerEvent);
    _socket.on("instance:delete_multiple", _deleteMultipleServerEvents);
    _socket.on("instance:restore", _restoreServerEvent);
    _socket.on("instance:restore_multiple", _restoreMultipleEvents);
  }

  Future<void> _createServerInstance(data) async {
    NetworkActivityInstance instance = NetworkActivityInstance.fromJson(data);

    final List<ActivityInstance> newInstances = [
      ..._instancesStreamController.value
    ];

    newInstances.add(instance.asExternalInstance());

    _instancesStreamController.add(newInstances);
  }

  Future<void> _editServerInstance(data) async {
    NetworkActivityInstance networkInstance =
        NetworkActivityInstance.fromJson(data);

    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    int idx = instances.indexWhere((ele) => ele.id == networkInstance.id);
    if (idx < 0) return;

    instances[idx] = networkInstance.asExternalInstance();
    _instancesStreamController.add(instances);
  }

  Future<void> _deleteServerEvent(data) async {
    String instanceId = data;

    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    int idx = instances.indexWhere((ele) => ele.id == instanceId);
    if (idx < 0) return;

    instances.removeAt(idx);
    _instancesStreamController.add(instances);
  }

  Future<void> _restoreServerEvent(data) async {
    NetworkActivityInstance networkInstance =
        NetworkActivityInstance.fromJson(data);

    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];
    ActivityInstance instance = networkInstance.asExternalInstance();
    int i = 0;
    for (; i < instances.length; i++) {
      if (instance.createdAt.compareTo(instances[i].createdAt) <= 0) {
        break;
      }
    }

    if (i == instances.length)
      instances.add(instance);
    else
      instances.insert(i, instance);

    _instancesStreamController.add(instances);
  }

  Future<void> _deleteMultipleServerEvents(data) async {
    final ids = (data["ids"] as List<dynamic>).map((id) => id.toString());

    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    instances.removeWhere((instance) => ids.contains(instance.id));

    _instancesStreamController.add(instances);
  }

  Future<void> _restoreMultipleEvents(data) async {
    final rawInstancesList = data as List<dynamic>;

    final List<ActivityInstance> instances = [
      ..._instancesStreamController.value
    ];

    final Set<String> existingInstancesIds =
        Set.from(instances.map((instance) => instance.id));

    for (int i = 0; i < rawInstancesList.length; i++) {
      final instance = NetworkActivityInstance.fromJson(rawInstancesList[i]);

      if (!existingInstancesIds.contains(instance.id)) {
        instances.add(instance.asExternalInstance());
      }
    }

    _instancesStreamController.add(instances);
  }
}
