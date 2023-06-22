import 'package:flutter/material.dart';

import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:material_design_icons_flutter/icon_map.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';

class IconChooserDialog extends StatefulWidget {
  const IconChooserDialog({
    super.key,
  });

  @override
  State<IconChooserDialog> createState() => _IconChooserDialogState();
}

class _IconChooserDialogState extends State<IconChooserDialog> {
  final List<String> allKeys =
      iconMap.keys.where((iconName) => !iconName.endsWith('Outline')).toList();

  List<String>? filteredKeys;

  final TextEditingController _searchController = TextEditingController();

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose an Icon",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
            MaterialSearchBar(
              controller: _searchController,
              autofocus: true,
              hintText: "Search Icons",
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    filteredKeys = null;
                  });
                } else {
                  final res = extractTop(
                    query: value,
                    choices: allKeys,
                    limit: 100,
                    cutoff: 60,
                  );
                  setState(() {
                    filteredKeys = res.map((e) => allKeys[e.index]).toList();
                  });
                }
              },
            ),
            const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
            Expanded(
              child: GridView.builder(
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: iconsPerRow,
                // ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 72,
                ),
                itemCount: filteredKeys?.length ?? allKeys.length,
                itemBuilder: (context, index) {
                  final keys = filteredKeys ?? allKeys;

                  IconData iconData = IconData(
                    iconMap[keys[index]]!,
                    fontFamily: "Material Design Icons",
                    fontPackage: "material_design_icons_flutter",
                  );

                  return IconButton(
                    onPressed: () {
                      Navigator.pop(context, iconData);
                    },
                    iconSize: kDefaultIconSize * 1.25,
                    icon: Icon(iconData),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
