import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.timelapse,
      color: Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
}
