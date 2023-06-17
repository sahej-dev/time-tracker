import 'package:flutter/material.dart';

import 'package:activities_repository/activities_repository.dart';

import '../../../widgets/widgets.dart';

class ActivityChooserField extends StatelessWidget {
  const ActivityChooserField({
    super.key,
    required this.selectedActivity,
    required this.labelText,
    this.onTap,
  });

  final Activity? selectedActivity;
  final String labelText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          margin: EdgeInsets.only(
            top: (Theme.of(context).textTheme.bodySmall!.fontSize! *
                    Theme.of(context).textTheme.bodySmall!.height!) *
                0.5,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              // default for text field
              vertical: 4,
              horizontal: 12,
            ),
            leading: selectedActivity != null
                ? ActivityLogoOnlyIcon(activity: selectedActivity)
                : null,
            title: Text(
              selectedActivity?.label ?? labelText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: onTap,
          ),
        ),
        if (selectedActivity != null)
          Positioned(
            top: 0,
            left: 8,
            child: Card(
              margin: const EdgeInsets.all(0),
              shadowColor: Colors.transparent,
              color: Theme.of(context).colorScheme.surface,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  labelText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
