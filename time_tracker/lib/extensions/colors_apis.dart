import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';

extension HarmonizedColorsGenerator on Color {
  Color Function(BuildContext) get backgroundColor =>
      (BuildContext context) => harmonizeWith(
            Theme.of(context).colorScheme.primary,
          ).withAlpha(50);
}
