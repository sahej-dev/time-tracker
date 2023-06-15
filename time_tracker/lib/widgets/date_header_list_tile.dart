import 'package:flutter/material.dart';

import 'package:moment_dart/moment_dart.dart';

class DateHeaderListTile extends StatelessWidget {
  const DateHeaderListTile({
    super.key,
    required this.areAllInstanceOfDateSelected,
    required this.dateTime,
    this.onTap,
  });

  final bool areAllInstanceOfDateSelected;
  final DateTime dateTime;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enableFeedback: true,
      onTap: onTap,
      title: Text(
        dateTime.toMoment().toLocal().formatDate(),
      ),
      trailing: areAllInstanceOfDateSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(Icons.check_circle_outline_rounded),
    );
  }
}
