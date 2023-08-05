import 'package:flutter/material.dart';
import 'package:realtime_activities_repository/realtime_activities_repository.dart';

import '../../extensions/extensions.dart';
import '../../constants/constants.dart';

class ActivityGridTile extends StatelessWidget {
  const ActivityGridTile({
    super.key,
    required this.activity,
    this.onTap,
    this.onLongPress,
    this.iconSize,
    this.labelMaxLines,
    this.labelPadding,
    this.labelTextStyle,
    this.showBorder,
  });

  final Activity activity;
  final double? iconSize;
  final int? labelMaxLines;
  final double? labelPadding;
  final TextStyle? labelTextStyle;
  final bool? showBorder;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final Color color = activity.getColor(context);

    return GridTile(
      child: Container(
        decoration: showBorder == true
            ? BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          shadowColor: Colors.transparent,
          surfaceTintColor: color,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  activity.iconData,
                  color: color,
                  size: iconSize ?? (kDefaultIconSize * 1.5),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    labelPadding ?? (kDefaultPadding * 0.5),
                  ),
                  child: Text(
                    activity.label,
                    style:
                        labelTextStyle ?? Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                    maxLines: labelMaxLines ?? 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
