import 'package:flutter/material.dart';

import '../responsive/responsive.dart';

class AdaptiveFab extends StatelessWidget {
  const AdaptiveFab({super.key, required this.onPressed, this.child});

  final void Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ScreenType screenType = getScreenType(context);

    return FloatingActionButton(
      elevation: screenType != ScreenType.mobile ? 0 : null,
      hoverElevation: screenType != ScreenType.mobile ? 1 : null,
      onPressed: onPressed,
      child: child,
    );
  }
}
