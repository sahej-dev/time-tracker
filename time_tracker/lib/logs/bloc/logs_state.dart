part of 'logs_bloc.dart';

class LogsState extends Equatable {
  final List<ActivityInstance> instances;
  final LoadingStatus loadingStatus;
  final Exception? exception;

  const LogsState._({
    this.instances = const [],
    this.loadingStatus = LoadingStatus.initial,
    this.exception,
  });

  const LogsState.initial() : this._();

  @override
  List<Object?> get props => [loadingStatus, instances, exception];

  LogsState copyWith({
    LoadingStatus? loadingStatus,
    List<ActivityInstance>? instances,
    Exception? exception,
  }) {
    return LogsState._(
      instances: instances ?? this.instances,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      exception: (loadingStatus ?? this.loadingStatus) != LoadingStatus.error
          ? null
          : (exception ?? this.exception),
    );
  }

  ActivityInstance? get runningInstance {
    int idx = instances.indexWhere((instance) => instance.endAt == null);
    if (idx < 0) return null;

    return instances[idx];
  }
}
