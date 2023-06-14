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
                return const Divider();
              },
              itemBuilder: (context, index) {
                ActivityInstance instance = state.instances[index];
                Activity? activity = state.activityForInstance(instance);

                TextStyle? subtitleTextStyle =
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        );

                return ListTile(
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
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      instance.endAt == null
                          ? Text(
                              "${instance.startAt.toMoment().toLocal().calendar(omitHours: true)} on going",
                              style: subtitleTextStyle,
                            )
                          : Text(
                              "${instance.startAt.toMoment().toLocal().calendar(omitHours: true)} for ${instance.duration!.toDurationString(
                                form: UnitStringForm.short,
                                dropPrefixOrSuffix: true,
                              )}",
                              style: subtitleTextStyle,
                            ),
                      Text(
                        "${instance.startAt.toMoment().toLocal().formatTime()} - ${instance.endAt == null ? 'now' : instance.endAt!.toMoment().toLocal().formatTime()}",
                        style: subtitleTextStyle,
                      ),
                    ],
                  ),
                  iconColor: activity?.getColor(context) ??
                      Theme.of(context).colorScheme.primary,
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
