import 'package:freezed_annotation/freezed_annotation.dart';

import 'icon_metadata.dart';

part 'icon_model.freezed.dart';
part 'icon_model.g.dart';

@freezed
class IconModel with _$IconModel {
  @JsonSerializable(explicitToJson: true)
  const factory IconModel({
    required String id,
    required int codepoint,
    @JsonKey(name: 'metadata') required IconMetadata metadata,
    required DateTime createdAt,
  }) = _IconModel;

  @override
  factory IconModel.fromJson(Map<String, dynamic> json) =>
      _$IconModelFromJson(json);
}
