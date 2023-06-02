// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

IconMetadata _$IconMetadataFromJson(Map<String, dynamic> json) {
  return _IconMetadata.fromJson(json);
}

/// @nodoc
mixin _$IconMetadata {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'font_family')
  String? get fontFamily => throw _privateConstructorUsedError;
  @JsonKey(name: 'font_package')
  String? get fontPackage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IconMetadataCopyWith<IconMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IconMetadataCopyWith<$Res> {
  factory $IconMetadataCopyWith(
          IconMetadata value, $Res Function(IconMetadata) then) =
      _$IconMetadataCopyWithImpl<$Res, IconMetadata>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'font_family') String? fontFamily,
      @JsonKey(name: 'font_package') String? fontPackage});
}

/// @nodoc
class _$IconMetadataCopyWithImpl<$Res, $Val extends IconMetadata>
    implements $IconMetadataCopyWith<$Res> {
  _$IconMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fontFamily = freezed,
    Object? fontPackage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: freezed == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      fontPackage: freezed == fontPackage
          ? _value.fontPackage
          : fontPackage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_IconMetadataCopyWith<$Res>
    implements $IconMetadataCopyWith<$Res> {
  factory _$$_IconMetadataCopyWith(
          _$_IconMetadata value, $Res Function(_$_IconMetadata) then) =
      __$$_IconMetadataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'font_family') String? fontFamily,
      @JsonKey(name: 'font_package') String? fontPackage});
}

/// @nodoc
class __$$_IconMetadataCopyWithImpl<$Res>
    extends _$IconMetadataCopyWithImpl<$Res, _$_IconMetadata>
    implements _$$_IconMetadataCopyWith<$Res> {
  __$$_IconMetadataCopyWithImpl(
      _$_IconMetadata _value, $Res Function(_$_IconMetadata) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fontFamily = freezed,
    Object? fontPackage = freezed,
  }) {
    return _then(_$_IconMetadata(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: freezed == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      fontPackage: freezed == fontPackage
          ? _value.fontPackage
          : fontPackage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_IconMetadata implements _IconMetadata {
  const _$_IconMetadata(
      {required this.id,
      @JsonKey(name: 'font_family') this.fontFamily,
      @JsonKey(name: 'font_package') this.fontPackage});

  factory _$_IconMetadata.fromJson(Map<String, dynamic> json) =>
      _$$_IconMetadataFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'font_family')
  final String? fontFamily;
  @override
  @JsonKey(name: 'font_package')
  final String? fontPackage;

  @override
  String toString() {
    return 'IconMetadata(id: $id, fontFamily: $fontFamily, fontPackage: $fontPackage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_IconMetadata &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.fontPackage, fontPackage) ||
                other.fontPackage == fontPackage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fontFamily, fontPackage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_IconMetadataCopyWith<_$_IconMetadata> get copyWith =>
      __$$_IconMetadataCopyWithImpl<_$_IconMetadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_IconMetadataToJson(
      this,
    );
  }
}

abstract class _IconMetadata implements IconMetadata {
  const factory _IconMetadata(
          {required final String id,
          @JsonKey(name: 'font_family') final String? fontFamily,
          @JsonKey(name: 'font_package') final String? fontPackage}) =
      _$_IconMetadata;

  factory _IconMetadata.fromJson(Map<String, dynamic> json) =
      _$_IconMetadata.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'font_family')
  String? get fontFamily;
  @override
  @JsonKey(name: 'font_package')
  String? get fontPackage;
  @override
  @JsonKey(ignore: true)
  _$$_IconMetadataCopyWith<_$_IconMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}
