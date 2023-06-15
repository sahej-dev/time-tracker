import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instances_repository/instances_repository.dart';

import '../bloc/logs_bloc.dart';
import '../../activities/activities.dart';
import '../../constants/constants.dart';
import '../../types.dart';
import '../../widgets/widgets.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  static PreferredSizeWidget? Function() appBarBuilder() => () => AppBar(
        title: const Text("Log Activities"),
      );
  static PreferredSizeWidget? Function() fabBuilder() => () => null;

  void _stopRunningInstance(BuildContext context) {
    context.read<LogsBloc>().add(
          LogsInstanceStopped(
            stopTime: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, activitiesState) {
        return BlocBuilder<LogsBloc, LogsState>(
          builder: (context, logsState) {
            switch (LoadingStatusMixer.mix([
              activitiesState.loadingStatus,
              logsState.loadingStatus,
            ])) {
              case LoadingStatus.initial:
              case LoadingStatus.pending:
                return const LoadingIndicator();

              case LoadingStatus.error:
                return ErrorDisplay(
                  error: activitiesState.exception ?? logsState.exception,
                );

              case LoadingStatus.success:
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    children: [
                      if (logsState.runningInstance != null)
                        OnGoingActivityTile(
                          instance: logsState.runningInstance!,
                          activity: activitiesState.activities.firstWhere(
                            (activity) =>
                                activity.id ==
                                logsState.runningInstance!.activityId,
                          ),
                          onDeletePressed: () {
                            final bloc = context.read<LogsBloc>();
                            final instance = logsState.runningInstance!;

                            bloc.add(LogsInstanceDeleted(instance: instance));

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text('Deleted current log'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      bloc.add(
                                        const LogsTryUndoLastDeleted(),
                                      );
                                    },
                                  ),
                                  showCloseIcon: true,
                                ),
                              );
                          },
                          onStopPressed: () {
                            _stopRunningInstance(context);
                          },
                        ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: activitiesState.activities.length,
                          itemBuilder: (context, index) {
                            final activity = activitiesState.activities[index];
                            return GridTile(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ActivityGridTile(
                                    activity: activity,
                                    onTap: () {
                                      if (logsState
                                              .runningInstance?.activityId ==
                                          activity.id) {
                                        _stopRunningInstance(context);
                                      } else {
                                        // add new instance
                                        context.read<LogsBloc>().add(
                                              LogsInstanceAdded(
                                                instance: ActivityInstance(
                                                  activityId: activity.id,
                                                  startAt: DateTime.now(),
                                                ),
                                              ),
                                            );
                                      }
                                    },
                                    onLongPress: () {},
                                  ),
                                  if (activity.id ==
                                      logsState.runningInstance?.activityId)
                                    const Positioned(
                                      right: kDefaultPadding * 0.75,
                                      top: kDefaultPadding * 0.75,
                                      child: ActiveDot(),
                                    )
                                ],
                              ),
                            );
                          },
                          gridDelegate: kDefaultGridDelegate,
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return Text(
                  "Uknown loading state ${activitiesState.loadingStatus}. Please contact developers",
                  style: Theme.of(context).textTheme.bodyLarge,
                );
            }
          },
        );
      },
    );
  }
}
