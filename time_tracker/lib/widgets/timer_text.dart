import 'dart:async';

import 'package:flutter/material.dart';

class TimerText extends StatefulWidget {
  const TimerText({
    super.key,
    required this.startTime,
    this.style,
  });

  final DateTime startTime;
  final TextStyle? style;

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  late String durationString;

  @override
  void initState() {
    super.initState();

    durationString =
        toFormattedString(DateTime.now().difference(widget.startTime));

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        durationString =
            toFormattedString(DateTime.now().difference(widget.startTime));
      });
    });
  }

  String toFormattedString(Duration duration) {
    List<String> elements = duration.toString().split('.')[0].split(':');

    while ((elements[0] == '0' || elements[0] == '00') && elements.length > 2) {
      elements.removeAt(0);
    }
    if (elements[0].startsWith('0') && elements[0].length > 1) {
      elements[0] = elements[0].substring(1);
    }
    return elements.join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      durationString,
      style: widget.style,
    );
  }
}
