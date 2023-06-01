import 'package:flutter/material.dart';

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: child,
      ),
    );
  }
}
