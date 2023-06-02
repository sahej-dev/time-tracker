import 'package:freezed_annotation/freezed_annotation.dart';

import 'icon_metadata.dart';

part 'icon.freezed.dart';
part 'icon.g.dart';

@freezed
class Icon with _$Icon {
  const factory Icon({
    required String id,
    required int codepoint,
    @JsonKey(name: 'icon_metadata') required IconMetadata metadata,
  }) = _Icon;

  @override
  factory Icon.fromJson(Map<String, Object?> json) => _$IconFromJson(json);
}
