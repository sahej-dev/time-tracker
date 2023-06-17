import 'package:flutter/material.dart';

import 'package:activities_repository/activities_repository.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import '../../../activities/activities.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';

class ActivityChooserDialog extends StatefulWidget {
  const ActivityChooserDialog({
    super.key,
    required this.activitiesBloc,
  });

  final ActivitiesBloc activitiesBloc;

  @override
  State<ActivityChooserDialog> createState() => _ActivityChooserDialogState();
}

class _ActivityChooserDialogState extends State<ActivityChooserDialog> {
  List<Activity>? filteredActivities;

  final TextEditingController searchController = TextEditingController();

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
            const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
            MaterialSearchBar(
              controller: searchController,
              hintText: "Search activities",
              autofocus: true,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    filteredActivities = null;
                  });
                } else {
                  final res = extractTop<Activity>(
                    query: value,
                    choices: widget.activitiesBloc.state.activities,
                    limit: 100,
                    cutoff: 60,
                    getter: (activity) => activity.label,
                  );
                  setState(() {
                    filteredActivities = res.map((e) => e.choice).toList();
                  });
                }
              },
            ),
            const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
            Expanded(
              child: GridView.builder(
                itemCount: filteredActivities?.length ??
                    widget.activitiesBloc.state.activities.length,
                itemBuilder: (context, index) {
                  final activity = filteredActivities?[index] ??
                      widget.activitiesBloc.state.activities[index];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
