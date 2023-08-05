import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:realtime_activities_repository/realtime_activities_repository.dart';

extension FlutterObjectGenerator on Activity {
  Color getColor(BuildContext context) {
    return (color ?? Theme.of(context).colorScheme.surfaceTint)
        .harmonizeWith(Theme.of(context).colorScheme.primary);
  }
}
