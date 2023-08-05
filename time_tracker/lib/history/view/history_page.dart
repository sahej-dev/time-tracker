import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_activities_repository/realtime_activities_repository.dart';
import 'package:realtime_instances_repository/realtime_instances_repository.dart';
import 'package:moment_dart/moment_dart.dart';

import 'widgets/widgets.dart';
import '../bloc/history_bloc.dart';
import '../../logs/logs.dart';
import '../../widgets/widgets.dart';
import '../../types.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static PreferredSizeWidget? Function() appBarBuilder(BuildContext context) =>
      () => PreferredSize(
            preferredSize: Size.fromHeight(
              AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight,
            ),
            child: const HistoryAppBar(),
          );
  static PreferredSizeWidget? Function() fabBuilder() => () => null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        switch (state.loadingStatus) {
          case LoadingStatus.initial:
          case LoadingStatus.pending:
            return const LoadingIndicator();

          case LoadingStatus.error:
            return ErrorDisplay(
              error: state.exception,
            );

          case LoadingStatus.success:
            return ListView.separated(
              itemCount: state.instances.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 0,
                );
              },
              itemBuilder: (context, index) {
                ActivityInstance instance = state.instances[index];
                Activity? activity = state.activityForInstance(instance);
                bool isTileSelected =
                    state.selectedInstances.contains(instance);
                bool isAnySelectionPresent = state.selectedInstances.isNotEmpty;

                final listTile = HistoryLogListTile(
                  isTileSelected: isTileSelected,
                  isAnySelectionPresent: isAnySelectionPresent,
                  instance: instance,
                  activity: activity,
                  onTap: () {
                    if (!isAnySelectionPresent) {
                      LogsForm.showAddEditBottomSheet(
                        context,
                        instance: instance,
                      );

                      return;
                    }

                    if (!isTileSelected) {
                      context.read<HistoryBloc>().add(
                            HistoryInstanceSelected(instance: instance),
                          );
                    } else {
                      context.read<HistoryBloc>().add(
                            HistoryInstanceUnselected(instance: instance),
                          );
                    }
                  },
                );

                Widget? dateListTile = dateHeaderTileBuilder(
                  context: context,
                  index: index,
                  instances: state.instances,
                  selectedInstances: state.selectedInstances,
                );

                return Column(
                  children: [
                    if (dateListTile != null) dateListTile,
                    listTile,
                  ],
                );
              },
            );

          default:
            return Text(
              "Uknown loading state ${state.loadingStatus}. Please contact developers",
              style: Theme.of(context).textTheme.bodyLarge,
            );
        }
      },
    );
  }

  /// builds a [DateHeaderListTile] if required, otherwise returns null
  Widget? dateHeaderTileBuilder({
    required final BuildContext context,
    required final int index,
    required final List<ActivityInstance> instances,
    required final List<ActivityInstance> selectedInstances,
  }) {
    Widget? dateListTile;
    ActivityInstance instance = instances[index];

    ActivityInstance? lastInstance;
    if (index > 0) lastInstance = instances[index - 1];

    Moment? lastInstanceDate = lastInstance?.startAt.toMoment().toLocal();
    Moment currInstanceDate = instance.startAt.toMoment().toLocal();

    final bool isFirstTileOfList = index == 0;
    final bool isFirstTileOfDate = lastInstanceDate != null &&
        !lastInstanceDate.isAtSameDayAs(currInstanceDate);

    if (isFirstTileOfList || isFirstTileOfDate) {
      final List<ActivityInstance> instancesOfDate = instances
          .where((instance) => instance.startAt
              .toMoment()
              .toLocal()
              .isAtSameDayAs(currInstanceDate))
          .toList();

      bool areAllInstanceOfDateSelected = true;

      for (int i = 0; i < instancesOfDate.length; i++) {
        if (!selectedInstances.contains(instancesOfDate[i])) {
          areAllInstanceOfDateSelected = false;
          break;
        }
      }

      dateListTile = DateHeaderListTile(
        areAllInstanceOfDateSelected: areAllInstanceOfDateSelected,
        dateTime: instance.startAt,
        onTap: () {
          if (areAllInstanceOfDateSelected) {
            context.read<HistoryBloc>().add(HistoryUnselectAllOnDate(
                  dateTime: instance.startAt,
                ));
          } else {
            context.read<HistoryBloc>().add(HistorySelectAllOnDate(
                  dateTime: instance.startAt,
                ));
          }
        },
      );
    }

    return dateListTile;
  }
}
