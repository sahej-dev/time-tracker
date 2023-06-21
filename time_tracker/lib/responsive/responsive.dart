import 'package:flutter/material.dart';

import '../constants/constants.dart';

class _BreakPoints {
  static double mobile = 600;
}

enum ScreenType { desktop, mobile }

ScreenType getScreenType(BuildContext context) {
  // Use .shortestSide to detect device type regardless of orientation
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > _BreakPoints.mobile) return ScreenType.desktop;
  return ScreenType.mobile;
}

class Responsive {
  static getDefaultGridDelegate(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.desktop:
        return kDefaultDesktopGridDelegate;

      case ScreenType.mobile:
        return kDefaultMobileGridDelegate;
      default:
    }
  }

  static getActivityChooserGridDelegate(BuildContext context) {
    ScreenType screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.desktop:
        return kDesktopActivityChooserGridDelegate;

      case ScreenType.mobile:
        return kMobileActivityChooserGridDelegate;
      default:
    }
  }
}
