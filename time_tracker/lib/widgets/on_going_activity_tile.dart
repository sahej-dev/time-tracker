import 'package:flutter/material.dart';

import 'package:activities_repository/activities_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instances_repository/instances_repository.dart';

import '../../constants/constants.dart';
import '../../widgets/widgets.dart';

class OnGoingActivityTile extends StatelessWidget {
  const OnGoingActivityTile({
    super.key,
    required this.activity,
    required this.instance,
    required this.onStopPressed,
    required this.onDeletePressed,
    this.margin,
  });

  final Activity activity;
  final ActivityInstance instance;
  final void Function()? onStopPressed;
  final void Function()? onDeletePressed;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 12,
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(
            Theme.of(context).brightness == Brightness.light ? 255 : 220,
          ),
      margin: margin ??
          const EdgeInsets.symmetric(
            vertical: kDefaultPadding * 0.5,
          ),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "On going activity",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  Text(
                    activity.label,
                    style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TimerText(
                  startTime: instance.startAt,
                  style: GoogleFonts.robotoMono(
                    textStyle: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  width: kDefaultPadding * 0.5,
                ),
                IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(Icons.delete_rounded),
                ),
                IconButton.outlined(
                  onPressed: onStopPressed,
                  color: Theme.of(context).colorScheme.error,
                  style: ButtonStyle(
                    side: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return null;
                      }
                      return BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      );
                    }),
                  ),
                  icon: const Icon(Icons.stop_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
