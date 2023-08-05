import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity.dart';
import 'icon_model.dart';

part 'network_activity.freezed.dart';
part 'network_activity.g.dart';

@freezed
class NetworkActivity with _$NetworkActivity {
  const NetworkActivity._();

  @JsonSerializable(explicitToJson: true)
  const factory NetworkActivity({
    required String id,
    required String label,
    required IconModel icon,
    required DateTime createdAt,
    int? color,
  }) = _NetworkActivity;

  factory NetworkActivity.fromJson(Map<String, dynamic> json) =>
      _$NetworkActivityFromJson(json);

  Activity asExternalActivity() {
    return Activity(
      id: id,
      label: label,
      iconData: IconData(
        icon.codepoint,
        fontFamily: icon.metadata.fontFamily,
        fontPackage: icon.metadata.fontPackage,
      ),
      color: color != null ? Color(color!) : null,
      createdAt: createdAt,
    );
  }
}
