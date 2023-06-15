import 'package:flutter/material.dart';

class ActiveDot extends StatelessWidget {
  const ActiveDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 224, 122),
        borderRadius: BorderRadius.circular(300),
      ),
      width: 8,
      height: 8,
    );
  }
}
