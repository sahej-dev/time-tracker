import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instances_repository/instances_repository.dart';

import 'logs_form.dart';
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
  static Widget? Function() fabBuilder() =>
      () => const _AddEditLogBottomSheetFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogsBloc, LogsState>(
      builder: (context, logsState) {
        switch (logsState.loadingStatus) {
          case LoadingStatus.initial:
          case LoadingStatus.pending:
            return const LoadingIndicator();

          case LoadingStatus.error:
            return ErrorDisplay(
              error: logsState.exception,
            );

          case LoadingStatus.success:
            return _LogsView(
              logsState: logsState,
            );
          default:
            return Text(
              "Uknown loading state ${logsState.loadingStatus}. Please contact developers",
              style: Theme.of(context).textTheme.bodyLarge,
            );
        }
      },
    );
  }
}

class _AddEditLogBottomSheetFloatingActionButton extends StatelessWidget {
  const _AddEditLogBottomSheetFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        LogsForm.showAddEditBottomSheet(context);
      },
      child: const Icon(Icons.add),
    );
  }
}

class _LogsView extends StatefulWidget {
  const _LogsView({required this.logsState});

  final LogsState logsState;

  @override
  State<_LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<_LogsView> {
  void _stopRunningInstance(BuildContext context) {
    context.read<LogsBloc>().add(
          LogsInstanceStopped(
            stopTime: DateTime.now().toLocal(),
          ),
        );
  }

  final ScrollController _gridViewScrollController =
      ScrollController(initialScrollOffset: 0);
  late double scrollOffset;

  @override
  void initState() {
    super.initState();
    scrollOffset = _gridViewScrollController.initialScrollOffset;
    _gridViewScrollController.addListener(() {
      if (scrollOffset * _gridViewScrollController.offset <= 0) {
        setState(() {
          scrollOffset = _gridViewScrollController.offset;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.logsState.runningInstance != null)
          Material(
            elevation: scrollOffset > 0 ? 3 : 0,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            shadowColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: OnGoingActivityTile(
                instance: widget.logsState.runningInstance!,
                activity: widget.logsState
                    .activityForInstance(widget.logsState.runningInstance!)!,
                onDeletePressed: () {
                  final bloc = context.read<LogsBloc>();
                  final instance = widget.logsState.runningInstance!;

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
            ),
          ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
              buildWhen: (previous, current) {
                return previous.activities != current.activities;
              },
              builder: (context, activitiesState) {
                return GridView.builder(
                  controller: _gridViewScrollController,
                  itemCount: activitiesState.activities.length,
                  itemBuilder: (context, index) {
                    final activity = activitiesState.activities[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ActivityGridTile(
                          activity: activity,
                          onTap: () {
                            if (widget.logsState.runningInstance?.activityId ==
                                activity.id) {
                              _stopRunningInstance(context);
                            } else {
                              // add new instance
                              context.read<LogsBloc>().add(
                                    LogsInstanceAdded(
                                      instance: ActivityInstance(
                                        activityId: activity.id,
                                        startAt: DateTime.now().toLocal(),
                                      ),
                                    ),
                                  );
                            }
                          },
                          onLongPress: () {},
                        ),
                        if (activity.id ==
                            widget.logsState.runningInstance?.activityId)
                          const Positioned(
                            right: kDefaultPadding * 0.75,
                            top: kDefaultPadding * 0.75,
                            child: ActiveDot(),
                          )
                      ],
                    );
                  },
                  gridDelegate: kDefaultGridDelegate,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
