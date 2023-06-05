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
    required ActivitiesBloc activitiesBloc,
  }) : _activitiesBloc = activitiesBloc;

  final ActivitiesBloc _activitiesBloc;
  final Color defaultColor;
  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  late Icon chosenIcon;
  late Color chosenColor;
  TextEditingController activityNameController = TextEditingController();

  Icon getDefaultIcon() {
    return const Icon(MdiIcons.pencil);
  }

  Color getDefaultColor() {
    return widget.defaultColor;
  }

  @override
  void initState() {
    super.initState();
    chosenIcon = getDefaultIcon();
    chosenColor = getDefaultColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create new activity",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
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
                  color: chosenColor,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      chosenColor
                          .harmonizeWith(
                            Theme.of(context).colorScheme.secondaryContainer,
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
                        allowCustom: true,
                        initialColor: chosenColor,
                      ),
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
            FilledButton(
                onPressed: () {
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

                  Navigator.of(context).pop();
                },
                child: const Text("Done")),
          ],
        )
      ],
    );
  }
}
