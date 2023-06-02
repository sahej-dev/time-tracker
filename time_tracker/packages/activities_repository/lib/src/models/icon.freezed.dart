// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Icon _$IconFromJson(Map<String, dynamic> json) {
  return _Icon.fromJson(json);
}

/// @nodoc
mixin _$Icon {
  String get id => throw _privateConstructorUsedError;
  int get codepoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_metadata')
  IconMetadata get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IconCopyWith<Icon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IconCopyWith<$Res> {
  factory $IconCopyWith(Icon value, $Res Function(Icon) then) =
      _$IconCopyWithImpl<$Res, Icon>;
  @useResult
  $Res call(
      {String id,
      int codepoint,
      @JsonKey(name: 'icon_metadata') IconMetadata metadata});

  $IconMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$IconCopyWithImpl<$Res, $Val extends Icon>
    implements $IconCopyWith<$Res> {
  _$IconCopyWithImpl(this._value, this._then);

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
abstract class _$$_IconCopyWith<$Res> implements $IconCopyWith<$Res> {
  factory _$$_IconCopyWith(_$_Icon value, $Res Function(_$_Icon) then) =
      __$$_IconCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int codepoint,
      @JsonKey(name: 'icon_metadata') IconMetadata metadata});

  @override
  $IconMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_IconCopyWithImpl<$Res> extends _$IconCopyWithImpl<$Res, _$_Icon>
    implements _$$_IconCopyWith<$Res> {
  __$$_IconCopyWithImpl(_$_Icon _value, $Res Function(_$_Icon) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codepoint = null,
    Object? metadata = null,
  }) {
    return _then(_$_Icon(
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
@JsonSerializable()
class _$_Icon implements _Icon {
  const _$_Icon(
      {required this.id,
      required this.codepoint,
      @JsonKey(name: 'icon_metadata') required this.metadata});

  factory _$_Icon.fromJson(Map<String, dynamic> json) => _$$_IconFromJson(json);

  @override
  final String id;
  @override
  final int codepoint;
  @override
  @JsonKey(name: 'icon_metadata')
  final IconMetadata metadata;

  @override
  String toString() {
    return 'Icon(id: $id, codepoint: $codepoint, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Icon &&
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
  _$$_IconCopyWith<_$_Icon> get copyWith =>
      __$$_IconCopyWithImpl<_$_Icon>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_IconToJson(
      this,
    );
  }
}

abstract class _Icon implements Icon {
  const factory _Icon(
      {required final String id,
      required final int codepoint,
      @JsonKey(name: 'icon_metadata')
          required final IconMetadata metadata}) = _$_Icon;

  factory _Icon.fromJson(Map<String, dynamic> json) = _$_Icon.fromJson;

  @override
  String get id;
  @override
  int get codepoint;
  @override
  @JsonKey(name: 'icon_metadata')
  IconMetadata get metadata;
  @override
  @JsonKey(ignore: true)
  _$$_IconCopyWith<_$_Icon> get copyWith => throw _privateConstructorUsedError;
}
