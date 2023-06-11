import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instances_repository/instances_repository.dart';

import '../../types.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc({required InstancesRepository instancesRepository})
      : _instancesRepository = instancesRepository,
        super(const LogsState.initial()) {
    on<LogsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final InstancesRepository _instancesRepository;

  Future<void> _onSubscriptionRequested(
    LogsSubscriptionRequested event,
    Emitter<LogsState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.pending));

    await emit.forEach<List<ActivityInstance>>(
      _instancesRepository.getInstances(),
      onData: (instances) {
        return state.copyWith(
          loadingStatus: LoadingStatus.success,
          instances: instances,
        );
      },
    );
  }
}
