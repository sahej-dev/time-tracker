import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:activities_repository/activities_repository.dart';

extension FlutterObjectGenerator on Activity {
  Color getColor(BuildContext context) {
    return Color(
      color ?? Theme.of(context).colorScheme.surfaceTint.value,
    ).harmonizeWith(Theme.of(context).colorScheme.primary);
  }

  IconData getIconData() {
    return IconData(
      icon.codepoint,
      fontFamily: icon.metadata.fontFamily,
      fontPackage: icon.metadata.fontPackage,
    );
  }
}
