import 'package:flutter/material.dart';

import 'app_logo.dart';
import '../constants/constants.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final chosenTextStyle =
        textStyle ?? Theme.of(context).textTheme.displayMedium;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(
          size: chosenTextStyle?.fontSize,
        ),
        const Padding(padding: EdgeInsets.only(left: kDefaultPadding)),
        Text(
          AppConstants.title,
          style: chosenTextStyle?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
