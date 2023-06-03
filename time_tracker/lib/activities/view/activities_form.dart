import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/constants.dart';
import './widgets/widgets.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({
    super.key,
    this.defaultColor = Colors.green,
  });

  final Color defaultColor;
  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  late Widget chosenIcon;
  late Color chosenColor;
  TextEditingController activityNameController = TextEditingController();

  Widget getDefaultIcon() {
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
      // mainAxisSize: MainAxisSize.min,
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
          // autofocus: true,
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
            FilledButton(onPressed: () {}, child: const Text("Done")),
          ],
        )
      ],
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    this.allowCustom = false,
  });

  final bool allowCustom;
  final Color initialColor;
  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  bool isShowingCustom = false;
  late Color currentColor;

  void onColorChanged(Color newColor) {
    setState(() {
      currentColor = newColor;
    });
  }

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose a Color',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      content: SingleChildScrollView(
        child: isShowingCustom
            ? ColorPicker(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                pickerAreaBorderRadius:
                    BorderRadius.circular(kDefaultBorderRadius),
              )
            : BlockPicker(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                itemBuilder: (color, isCurrentColor, changeColor) {
                  return Padding(
                    padding: const EdgeInsets.all(kDefaultPadding * 0.375),
                    child: IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context, color);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(color),
                      ),
                      icon: const SizedBox.shrink(),
                    ),
                  );
                },
              ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isShowingCustom
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isShowingCustom = false;
                      });
                    },
                    child: const Text("Presets"))
                : widget.allowCustom
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            isShowingCustom = true;
                          });
                        },
                        child: const Text("Custom"))
                    : const SizedBox.shrink(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: kDefaultPadding * 0.5),
                ),
                if (isShowingCustom)
                  FilledButton(
                    child: const Text('Done'),
                    onPressed: () {
                      Navigator.pop(context, currentColor);
                    },
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
