import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../bloc/summary_bloc.dart';
import '../../extensions/extensions.dart';
import '../../types.dart';
import '../../widgets/widgets.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  static PreferredSizeWidget? Function() appBarBuilder(BuildContext context) =>
      () => AppBar(
            title: const Text("Analytics"),
            actions: [
              const _DateRangeSelector(),
              PopupMenuButton(
                icon: const Icon(MdiIcons.wrench),
                itemBuilder: (context) {
                  final SummaryBloc bloc = context.read<SummaryBloc>();

                  return [
                    PopupMenuItem(
                      onTap: () {
                        bloc.add(const SummaryToggleUntrackedVisibility());
                      },
                      child: Text(
                        bloc.state.showUntracked
                            ? "Hide untracked"
                            : "Show untracked",
                      ),
                    ),
                  ];
                },
              )
            ],
          );
  static Widget? Function() fabBuilder() => () => const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryBloc, SummaryState>(
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
              itemCount: state.statistics.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 0,
                );
              },
              itemBuilder: (context, index) {
                final statistic = state.statistics[index];
                return ListTile(
                  leading: ActivityLogoOnlyIcon(activity: statistic.activity),
                  title: Text(
                    statistic.activity.label,
                  ),
                  subtitle: Text(
                    '${statistic.duration.toPrettyString} (${(statistic.percentage * 10000).toInt() / 100}%)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
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

class _DateRangeSelector extends StatelessWidget {
  const _DateRangeSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.date_range_rounded,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const Text("Today"),
            onTap: () {
              context.read<SummaryBloc>().add(
                    SummaryIntervalChangeRequested(
                      startDate: DateUtils.dateOnly(DateTime.now()),
                      endDate: DateTime.now(),
                    ),
                  );
            },
          ),
          PopupMenuItem(
            child: const Text("Yesterday"),
            onTap: () {
              context.read<SummaryBloc>().add(
                    SummaryIntervalChangeRequested(
                      startDate: DateUtils.dateOnly(DateTime.now().subtract(
                        const Duration(days: 1),
                      )),
                      endDate: DateUtils.dateOnly(DateTime.now()),
                    ),
                  );
            },
          ),
          PopupMenuItem(
            child: const Text("Last week"),
            onTap: () {
              context.read<SummaryBloc>().add(
                    SummaryIntervalChangeRequested(
                      startDate: DateUtils.dateOnly(DateTime.now().subtract(
                        const Duration(days: 7),
                      )),
                      endDate: DateUtils.dateOnly(DateTime.now()),
                    ),
                  );
            },
          ),
          PopupMenuItem(
            child: const Text("Custom"),
            onTap: () async {
              final SummaryBloc bloc = context.read<SummaryBloc>();

              final DateTime now = DateTime.now();

              // this onTap automatically calls Navigator.pop to close popup
              // so delay is added to avoid the range picker from closing as
              // soon as it opens
              await Future.delayed(
                const Duration(seconds: 0),
                () async {
                  final DateTimeRange? range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                    lastDate: now,
                    initialDateRange: DateTimeRange(
                      start: DateTime(now.year, now.month),
                      end: now,
                    ),
                  );

                  if (range == null) return;

                  bloc.add(SummaryIntervalChangeRequested(
                    startDate: range.start,
                    endDate: range.end,
                  ));
                },
              );
            },
          ),
        ];
      },
    );
  }
}
