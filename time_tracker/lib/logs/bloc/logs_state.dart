part of 'logs_bloc.dart';

class LogsState extends Equatable {
  final List<ActivityInstance> instances;
  final LoadingStatus loadingStatus;

  const LogsState._({
    this.instances = const [],
    this.loadingStatus = LoadingStatus.initial,
  });

  const LogsState.initial() : this._();

  @override
  List<Object?> get props => [];

  LogsState copyWith({
    LoadingStatus? loadingStatus,
    List<ActivityInstance>? instances,
  }) {
    return LogsState._(
      instances: instances ?? this.instances,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
