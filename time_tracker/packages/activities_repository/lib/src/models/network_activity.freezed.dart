// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NetworkActivity _$NetworkActivityFromJson(Map<String, dynamic> json) {
  return _NetworkActivity.fromJson(json);
}

/// @nodoc
mixin _$NetworkActivity {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  IconModel get icon => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkActivityCopyWith<NetworkActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkActivityCopyWith<$Res> {
  factory $NetworkActivityCopyWith(
          NetworkActivity value, $Res Function(NetworkActivity) then) =
      _$NetworkActivityCopyWithImpl<$Res, NetworkActivity>;
  @useResult
  $Res call(
      {String id,
      String label,
      IconModel icon,
      DateTime createdAt,
      int? color});

  $IconModelCopyWith<$Res> get icon;
}

/// @nodoc
class _$NetworkActivityCopyWithImpl<$Res, $Val extends NetworkActivity>
    implements $NetworkActivityCopyWith<$Res> {
  _$NetworkActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? icon = null,
    Object? createdAt = null,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $IconModelCopyWith<$Res> get icon {
    return $IconModelCopyWith<$Res>(_value.icon, (value) {
      return _then(_value.copyWith(icon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_NetworkActivityCopyWith<$Res>
    implements $NetworkActivityCopyWith<$Res> {
  factory _$$_NetworkActivityCopyWith(
          _$_NetworkActivity value, $Res Function(_$_NetworkActivity) then) =
      __$$_NetworkActivityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String label,
      IconModel icon,
      DateTime createdAt,
      int? color});

  @override
  $IconModelCopyWith<$Res> get icon;
}

/// @nodoc
class __$$_NetworkActivityCopyWithImpl<$Res>
    extends _$NetworkActivityCopyWithImpl<$Res, _$_NetworkActivity>
    implements _$$_NetworkActivityCopyWith<$Res> {
  __$$_NetworkActivityCopyWithImpl(
      _$_NetworkActivity _value, $Res Function(_$_NetworkActivity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? icon = null,
    Object? createdAt = null,
    Object? color = freezed,
  }) {
    return _then(_$_NetworkActivity(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_NetworkActivity extends _NetworkActivity {
  const _$_NetworkActivity(
      {required this.id,
      required this.label,
      required this.icon,
      required this.createdAt,
      this.color})
      : super._();

  factory _$_NetworkActivity.fromJson(Map<String, dynamic> json) =>
      _$$_NetworkActivityFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final IconModel icon;
  @override
  final DateTime createdAt;
  @override
  final int? color;

  @override
  String toString() {
    return 'NetworkActivity(id: $id, label: $label, icon: $icon, createdAt: $createdAt, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NetworkActivity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, label, icon, createdAt, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NetworkActivityCopyWith<_$_NetworkActivity> get copyWith =>
      __$$_NetworkActivityCopyWithImpl<_$_NetworkActivity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NetworkActivityToJson(
      this,
    );
  }
}

abstract class _NetworkActivity extends NetworkActivity {
  const factory _NetworkActivity(
      {required final String id,
      required final String label,
      required final IconModel icon,
      required final DateTime createdAt,
      final int? color}) = _$_NetworkActivity;
  const _NetworkActivity._() : super._();

  factory _NetworkActivity.fromJson(Map<String, dynamic> json) =
      _$_NetworkActivity.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  IconModel get icon;
  @override
  DateTime get createdAt;
  @override
  int? get color;
  @override
  @JsonKey(ignore: true)
  _$$_NetworkActivityCopyWith<_$_NetworkActivity> get copyWith =>
      throw _privateConstructorUsedError;
}
