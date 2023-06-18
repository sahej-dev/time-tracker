import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../constants/constants.dart';

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
