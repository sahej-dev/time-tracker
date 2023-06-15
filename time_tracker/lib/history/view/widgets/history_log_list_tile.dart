import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:instances_repository/instances_repository.dart';
import 'package:moment_dart/moment_dart.dart';

import '../../bloc/history_bloc.dart';
import '../../../constants/constants.dart';
import '../../../extensions/extensions.dart';

class HistoryLogListTile extends StatelessWidget {
  const HistoryLogListTile({
    super.key,
    required this.isTileSelected,
    required this.isAnySelectionPresent,
    required this.instance,
    required this.activity,
  });

  final bool isTileSelected;
  final bool isAnySelectionPresent;
  final ActivityInstance instance;
  final Activity? activity;

  @override
  Widget build(BuildContext context) {
    TextStyle? subtitleTextStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isTileSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            );
    return ListTile(
      onTap: () {
        if (!isAnySelectionPresent) return;

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
      onLongPress: () {
        if (isTileSelected) return;

        context.read<HistoryBloc>().add(
              HistoryInstanceSelected(instance: instance),
            );
      },
      enableFeedback: true,
      selected: isTileSelected,
      leading: Card(
        elevation: 12,
        shadowColor: Colors.transparent,
        surfaceTintColor: activity?.getColor(context),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding * 0.5),
          child: Icon(
            activity?.getIconData() ?? Icons.cancel,
            color: activity?.getColor(context) ??
                Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      trailing: !isAnySelectionPresent
          ? null
          : Icon(
              isTileSelected
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
            ),
      title: Text(
        activity?.label ?? '-',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${instance.startAt.toMoment().toLocal().formatTime()} - ${instance.endAt == null ? 'now' : instance.endAt!.toMoment().toLocal().formatTime()}${instance.endAt == null ? '' : ' (${instance.duration!.toDurationString(
            form: UnitStringForm.short,
            dropPrefixOrSuffix: true,
          )})'}",
        style: subtitleTextStyle,
      ),
    );
  }
}
