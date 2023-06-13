import 'package:activities_repository/activities_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import './widgets/widgets.dart';
import '../bloc/activities_bloc.dart';
import '../../constants/constants.dart';

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
  late Icon chosenIcon;
  late Color chosenColor;
  late TextEditingController activityNameController;
  Activity? activity;

  Icon getDefaultIcon() {
    return const Icon(MdiIcons.pencil);
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
      chosenIcon = getDefaultIcon();
      chosenColor = getDefaultColor();
    } else {
      // show page for editing existing activity
      activity = widget._activitiesBloc.state.activities[activityIdx];

      activityNameController = TextEditingController(text: activity!.label);
      chosenIcon = Icon(IconData(
        activity!.icon.codepoint,
        fontFamily: activity!.icon.metadata.fontFamily,
        fontPackage: activity!.icon.metadata.fontPackage,
      ));
      chosenColor =
          activity!.color != null ? Color(activity!.color!) : getDefaultColor();
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
                      chosenColor
                          .harmonizeWith(
                            Theme.of(context).colorScheme.primary,
                          )
                          .withAlpha(50),
                    ),
                  ),
                  onPressed: () async {
                    IconData? res = await showDialog<IconData>(
                      context: context,
                      builder: (BuildContext context) {
                        return const IconChooserDialog(
                          iconsPerRow: 5,
                        );
                      },
                    );

                    if (res != null) {
                      setState(() {
                        chosenIcon = Icon(res);
                      });
                    }
                  },
                  icon: chosenIcon,
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
                onPressed: () {
                  if (widget.id == null) {
                    widget._activitiesBloc.add(
                      ActivitiesNewAdded(
                        activity: Activity(
                          id: '',
                          label: activityNameController.text,
                          color: chosenColor.value,
                          createdAt: DateTime.now(),
                          icon: IconModel(
                            id: '',
                            codepoint: chosenIcon.icon!.codePoint,
                            createdAt: DateTime.now(),
                            metadata: IconMetadata(
                              id: '',
                              fontFamily: chosenIcon.icon?.fontFamily,
                              fontPackage: chosenIcon.icon?.fontPackage,
                              createdAt: DateTime.now(),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    widget._activitiesBloc.add(
                      ActivitiesEdited(
                        activity: Activity(
                          id: widget.id!,
                          label: activityNameController.text,
                          color: chosenColor.value,
                          createdAt: DateTime.now(),
                          icon: IconModel(
                            id: '',
                            codepoint: chosenIcon.icon!.codePoint,
                            createdAt: DateTime.now(),
                            metadata: IconMetadata(
                              id: '',
                              fontFamily: chosenIcon.icon?.fontFamily,
                              fontPackage: chosenIcon.icon?.fontPackage,
                              createdAt: DateTime.now(),
                            ),
                          ),
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
