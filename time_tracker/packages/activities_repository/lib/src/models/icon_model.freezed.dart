// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

IconModel _$IconModelFromJson(Map<String, dynamic> json) {
  return _IconModel.fromJson(json);
}

/// @nodoc
mixin _$IconModel {
  String get id => throw _privateConstructorUsedError;
  int get codepoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'metadata')
  IconMetadata get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IconModelCopyWith<IconModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IconModelCopyWith<$Res> {
  factory $IconModelCopyWith(IconModel value, $Res Function(IconModel) then) =
      _$IconModelCopyWithImpl<$Res, IconModel>;
  @useResult
  $Res call(
      {String id,
      int codepoint,
      @JsonKey(name: 'metadata') IconMetadata metadata});

  $IconMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$IconModelCopyWithImpl<$Res, $Val extends IconModel>
    implements $IconModelCopyWith<$Res> {
  _$IconModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codepoint = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      codepoint: null == codepoint
          ? _value.codepoint
          : codepoint // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as IconMetadata,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $IconMetadataCopyWith<$Res> get metadata {
    return $IconMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_IconModelCopyWith<$Res> implements $IconModelCopyWith<$Res> {
  factory _$$_IconModelCopyWith(
          _$_IconModel value, $Res Function(_$_IconModel) then) =
      __$$_IconModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int codepoint,
      @JsonKey(name: 'metadata') IconMetadata metadata});

  @override
  $IconMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_IconModelCopyWithImpl<$Res>
    extends _$IconModelCopyWithImpl<$Res, _$_IconModel>
    implements _$$_IconModelCopyWith<$Res> {
  __$$_IconModelCopyWithImpl(
      _$_IconModel _value, $Res Function(_$_IconModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codepoint = null,
    Object? metadata = null,
  }) {
    return _then(_$_IconModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      codepoint: null == codepoint
          ? _value.codepoint
          : codepoint // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as IconMetadata,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_IconModel implements _IconModel {
  const _$_IconModel(
      {required this.id,
      required this.codepoint,
      @JsonKey(name: 'metadata') required this.metadata});

  factory _$_IconModel.fromJson(Map<String, dynamic> json) =>
      _$$_IconModelFromJson(json);

  @override
  final String id;
  @override
  final int codepoint;
  @override
  @JsonKey(name: 'metadata')
  final IconMetadata metadata;

  @override
  String toString() {
    return 'IconModel(id: $id, codepoint: $codepoint, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_IconModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codepoint, codepoint) ||
                other.codepoint == codepoint) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, codepoint, metadata);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_IconModelCopyWith<_$_IconModel> get copyWith =>
      __$$_IconModelCopyWithImpl<_$_IconModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_IconModelToJson(
      this,
    );
  }
}

abstract class _IconModel implements IconModel {
  const factory _IconModel(
          {required final String id,
          required final int codepoint,
          @JsonKey(name: 'metadata') required final IconMetadata metadata}) =
      _$_IconModel;

  factory _IconModel.fromJson(Map<String, dynamic> json) =
      _$_IconModel.fromJson;

  @override
  String get id;
  @override
  int get codepoint;
  @override
  @JsonKey(name: 'metadata')
  IconMetadata get metadata;
  @override
  @JsonKey(ignore: true)
  _$$_IconModelCopyWith<_$_IconModel> get copyWith =>
      throw _privateConstructorUsedError;
}
