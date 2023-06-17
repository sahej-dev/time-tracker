import 'package:flutter/material.dart';

import '../../../activities/activities.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';

class ActivityChooserDialog extends StatelessWidget {
  const ActivityChooserDialog({
    super.key,
    required this.activitiesBloc,
  });

  final ActivitiesBloc activitiesBloc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding * 2,
          bottom: kDefaultPadding * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose activity",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: activitiesBloc.state.activities.length,
                itemBuilder: (context, index) {
                  final activity = activitiesBloc.state.activities[index];
                  return ActivityGridTile(
                    activity: activity,
                    iconSize: kDefaultIconSize,
                    labelMaxLines: 1,
                    labelPadding: kDefaultPadding * 0.25,
                    showBorder: true,
                    labelTextStyle: Theme.of(context).textTheme.bodySmall,
                    onTap: () {
                      Navigator.of(context).pop(activity);
                    },
                  );
                },
                gridDelegate: kActivityChooserGridDelegate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
