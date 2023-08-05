import 'package:flutter/material.dart';

import 'package:realtime_activities_repository/realtime_activities_repository.dart';

import '../constants/constants.dart';
import '../extensions/extensions.dart';

class ActivityLogoOnlyIcon extends StatelessWidget {
  const ActivityLogoOnlyIcon({
    super.key,
    required this.activity,
  });

  final Activity? activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shadowColor: Colors.transparent,
      surfaceTintColor: activity?.getColor(context),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding * 0.5),
        child: Icon(
          activity?.iconData ?? Icons.cancel,
          color: activity?.getColor(context) ??
              Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
