import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:instances_repository/instances_repository.dart';
import 'package:moment_dart/moment_dart.dart';

import '../bloc/history_bloc.dart';
import '../../constants/constants.dart';
import '../../widgets/widgets.dart';
import '../../extensions/extensions.dart';
import '../../types.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static PreferredSizeWidget? Function() appBarBuilder() => () => AppBar(
        title: const Text("Historical Logs"),
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

                TextStyle? subtitleTextStyle =
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        );

                final listTile = ListTile(
                  onTap: () {},
                  enableFeedback: true,
                  leading: Card(
                    elevation: 12,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: activity?.getColor(context),
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding * 0.5),
                      child: Icon(activity?.getIconData() ?? Icons.cancel),
                    ),
                  ),
                  title: Text(
                    activity?.label ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${instance.startAt.toMoment().toLocal().formatTime()} - ${instance.endAt == null ? 'now' : instance.endAt!.toMoment().toLocal().formatTime()}${instance.endAt == null ? '' : ' (${instance.duration!.toDurationString(
                            form: UnitStringForm.short,
                            dropPrefixOrSuffix: true,
                          )})'}",
                        style: subtitleTextStyle,
                      ),
                    ],
                  ),
                  iconColor: activity?.getColor(context) ??
                      Theme.of(context).colorScheme.primary,
                );

                ActivityInstance? lastInstance;
                if (index > 0) lastInstance = state.instances[index - 1];

                return Column(
                  children: [
                    if (index == 0 ||
                        (lastInstance != null &&
                            lastInstance.startAt
                                    .toMoment()
                                    .toLocal()
                                    .formatDate() !=
                                instance.startAt
                                    .toMoment()
                                    .toLocal()
                                    .formatDate()))
                      ListTile(
                        title: Text(
                            instance.startAt.toMoment().toLocal().formatDate()),
                      ),
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
}