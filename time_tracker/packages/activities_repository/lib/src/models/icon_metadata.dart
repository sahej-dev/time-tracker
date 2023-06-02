import 'package:freezed_annotation/freezed_annotation.dart';

part 'icon_metadata.freezed.dart';
part 'icon_metadata.g.dart';

@freezed
class IconMetadata with _$IconMetadata {
  const factory IconMetadata({
    required String id,
    @JsonKey(name: 'font_family') String? fontFamily,
    @JsonKey(name: 'font_package') String? fontPackage,
  }) = _IconMetadata;

  factory IconMetadata.fromJson(Map<String, Object?> json) =>
      _$IconMetadataFromJson(json);
}
