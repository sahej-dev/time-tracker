import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    this.error,
  });

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Card(
            surfaceTintColor: Theme.of(context).colorScheme.error,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding * 2,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size:
                            Theme.of(context).textTheme.displaySmall?.fontSize,
                      ),
                      const Padding(
                          padding: EdgeInsets.only(left: kDefaultPadding)),
                      Text(
                        "Error",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: kDefaultPadding)),
                  Text(
                    error?.toString() ?? "Unknown error occurred",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
