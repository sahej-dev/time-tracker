import 'package:activities_repository/activities_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import './widgets/widgets.dart';
import '../bloc/activities_bloc.dart';
import '../../constants/constants.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({
    super.key,
    this.defaultColor = Colors.green,
    this.id,
    required ActivitiesBloc activitiesBloc,
  }) : _activitiesBloc = activitiesBloc;

  final ActivitiesBloc _activitiesBloc;
  final Color defaultColor;
  final String? id;
  @override
  State<ActivityForm> createState() => _ActivityFormState();

  static Future<T?> showAddEditBottomSheet<T>({
    required BuildContext context,
    required ActivitiesBloc bloc,
    String? activityId,
  }) async {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
          child: ActivityForm(
            defaultColor: Theme.of(context).colorScheme.primary,
            activitiesBloc: bloc,
            id: activityId,
          ),
        );
      },
    );
  }
}

class _ActivityFormState extends State<ActivityForm> {
  late IconData chosenIconData;
  late Color chosenColor;
  late TextEditingController activityNameController;
  Activity? activity;

  IconData getDefaultIcon() {
    return MdiIcons.pencil;
  }

  Color getDefaultColor() {
    return widget.defaultColor;
  }

  @override
  void initState() {
    super.initState();

    int activityIdx = widget._activitiesBloc.state.activities
        .indexWhere((activity) => activity.id == widget.id);

    if (activityIdx == -1) {
      // show page for creating an activity
      activityNameController = TextEditingController();
      chosenIconData = getDefaultIcon();
      chosenColor = getDefaultColor();
    } else {
      // show page for editing existing activity
      activity = widget._activitiesBloc.state.activities[activityIdx];

      activityNameController = TextEditingController(text: activity!.label);
      chosenIconData = activity!.iconData;
      chosenColor = activity!.color ?? getDefaultColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.id == null ? "Create new activity" : "Edit activity",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding * 1.75)),
        TextField(
          controller: activityNameController,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Activity Name",
            hintText: "e.g. Gaming",
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Icon",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
                IconButton.filledTonal(
                  enableFeedback: true,
                  iconSize: kDefaultIconSize * 1.175,
                  color: chosenColor.harmonizeWith(
                    Theme.of(context).colorScheme.primary,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      chosenColor.backgroundColor(context),
                    ),
                  ),
                  onPressed: () async {
                    IconData? res = await showDialog<IconData>(
                      context: context,
                      builder: (BuildContext context) {
                        return const IconChooserDialog();
                      },
                    );

                    if (res != null) {
                      setState(() {
                        chosenIconData = res;
                      });
                    }
                  },
                  icon: Icon(chosenIconData),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Color",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
                IconButton.filled(
                  onPressed: () async {
                    final Color? res = await showDialog(
                      context: context,
                      builder: (context) => ColorPickerDialog(
                          allowCustom: true, initialColor: chosenColor),
                    );

                    if (res != null) {
                      setState(() {
                        chosenColor = res;
                      });
                    }
                  },
                  iconSize: kDefaultIconSize * 1.175,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(chosenColor),
                  ),
                  icon: const SizedBox.shrink(),
                )
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (activity != null)
              TextButton(
                onPressed: () {
                  widget._activitiesBloc.add(
                    ActivitiesDeleted(activity: activity!),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Deleted activity ${activity!.label}'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            widget._activitiesBloc.add(
                              const ActivitiesTryUndoLastDeleted(),
                            );
                          },
                        ),
                        showCloseIcon: true,
                      ),
                    );

                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
            FilledButton(
                onPressed: activityNameController.text.isEmpty
                    ? null
                    : () {
                        if (widget.id == null) {
                          widget._activitiesBloc.add(
                            ActivitiesNewAdded(
                              activity: Activity(
                                label: activityNameController.text,
                                iconData: chosenIconData,
                                color: chosenColor,
                              ),
                            ),
                          );
                        } else {
                          widget._activitiesBloc.add(
                            ActivitiesEdited(
                              activity: Activity(
                                id: widget.id,
                                label: activityNameController.text,
                                iconData: chosenIconData,
                                color: chosenColor,
                              ),
                            ),
                          );
                        }

                        Navigator.of(context).pop();
                      },
                child: const Text("Done")),
          ],
        )
      ],
    );
  }
}
