import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'activity.freezed.dart';

@freezed
class Activity with _$Activity {
  const factory Activity._def({
    required String id,
    required String label,
    required IconData iconData,
    required DateTime createdAt,
    Color? color,
  }) = _Activity;

  factory Activity({
    String? id,
    required String label,
    required IconData iconData,
    DateTime? createdAt,
    Color? color,
  }) {
    final uuid = Uuid();
    return Activity._def(
      id: id ?? uuid.v4(),
      label: label,
      iconData: iconData,
      createdAt: createdAt ?? DateTime.now(),
      color: color,
    );
  }
}
