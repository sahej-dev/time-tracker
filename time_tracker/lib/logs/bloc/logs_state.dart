part of 'logs_bloc.dart';

class LogsState extends Equatable {
  final List<ActivityInstance> instances;
  final LoadingStatus loadingStatus;
  final Exception? exception;
  final ActivityInstance? lastDeleted;

  const LogsState._({
    this.instances = const [],
    this.loadingStatus = LoadingStatus.initial,
    this.exception,
    this.lastDeleted,
  });

  const LogsState.initial() : this._();

  @override
  List<Object?> get props => [loadingStatus, instances, exception, lastDeleted];

  LogsState copyWith({
    LoadingStatus? loadingStatus,
    List<ActivityInstance>? instances,
    Exception? exception,
    ActivityInstance? lastDeleted,
  }) {
    return LogsState._(
      instances: instances ?? this.instances,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      lastDeleted: lastDeleted ?? this.lastDeleted,
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
