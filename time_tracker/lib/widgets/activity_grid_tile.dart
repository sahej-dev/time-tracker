import 'package:flutter/material.dart';
import 'package:activities_repository/activities_repository.dart';

import '../../extensions/extensions.dart';
import '../../constants/constants.dart';

class ActivityGridTile extends StatelessWidget {
  const ActivityGridTile({
    super.key,
    required this.activity,
    this.onTap,
    this.onLongPress,
  });

  final Activity activity;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final Color color = activity.getColor(context);

    return GridTile(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 12,
        shadowColor: Colors.transparent,
        surfaceTintColor: color,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                activity.getIconData(),
                color: color,
                size: kDefaultIconSize * 1.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.5),
                child: Text(
                  activity.label,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
