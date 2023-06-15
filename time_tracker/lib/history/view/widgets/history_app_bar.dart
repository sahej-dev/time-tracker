import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/history_bloc.dart';

class HistoryAppBar extends StatelessWidget {
  const HistoryAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      buildWhen: (previous, current) {
        return previous.selectedInstances != current.selectedInstances;
      },
      builder: (context, state) {
        bool areSelectionsPresent = state.selectedInstances.isNotEmpty;
        return AppBar(
          title: areSelectionsPresent
              ? Text("${state.selectedInstances.length} Selected")
              : const Text("Historical Logs"),
          leading: areSelectionsPresent
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<HistoryBloc>().add(const HistoryUnselectAll());
                  },
                )
              : null,
          actions: [
            if (areSelectionsPresent)
              PopupMenuButton<String>(
                elevation: 6,
                enableFeedback: true,
                itemBuilder: (context) {
                  return ['Delete']
                      .map((key) => PopupMenuItem(
                            value: key,
                            child: Text(key),
                          ))
                      .toList();
                },
                onSelected: (key) {
                  switch (key) {
                    case 'Delete':
                      context.read<HistoryBloc>().add(
                            const HistoryDeleteSelected(),
                          );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('Deleted selected logs'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                context.read<HistoryBloc>().add(
                                      const HistoryTryUndoLastDeleted(),
                                    );
                              },
                            ),
                            showCloseIcon: true,
                          ),
                        );
                      break;
                    default:
                  }
                },
              )
          ],
        );
      },
    );
  }
}
