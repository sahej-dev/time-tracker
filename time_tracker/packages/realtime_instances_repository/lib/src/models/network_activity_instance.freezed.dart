// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_activity_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NetworkActivityInstance _$NetworkActivityInstanceFromJson(
    Map<String, dynamic> json) {
  return _NetworkActivityInstance.fromJson(json);
}

/// @nodoc
mixin _$NetworkActivityInstance {
  String? get id => throw _privateConstructorUsedError;
  @DateTimeConverter()
  @JsonKey(name: 'start_at')
  DateTime get startAt => throw _privateConstructorUsedError;
  @DateTimeConverterNullable()
  @JsonKey(name: 'end_at')
  DateTime? get endAt => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  String get activityId => throw _privateConstructorUsedError;
  @DateTimeConverterNullable()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkActivityInstanceCopyWith<NetworkActivityInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkActivityInstanceCopyWith<$Res> {
  factory $NetworkActivityInstanceCopyWith(NetworkActivityInstance value,
          $Res Function(NetworkActivityInstance) then) =
      _$NetworkActivityInstanceCopyWithImpl<$Res, NetworkActivityInstance>;
  @useResult
  $Res call(
      {String? id,
      @DateTimeConverter() @JsonKey(name: 'start_at') DateTime startAt,
      @DateTimeConverterNullable() @JsonKey(name: 'end_at') DateTime? endAt,
      String? comment,
      @JsonKey(name: 'activity_id') String activityId,
      @DateTimeConverterNullable() DateTime? createdAt});
}

/// @nodoc
class _$NetworkActivityInstanceCopyWithImpl<$Res,
        $Val extends NetworkActivityInstance>
    implements $NetworkActivityInstanceCopyWith<$Res> {
  _$NetworkActivityInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? startAt = null,
    Object? endAt = freezed,
    Object? comment = freezed,
    Object? activityId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NetworkActivityInstanceCopyWith<$Res>
    implements $NetworkActivityInstanceCopyWith<$Res> {
  factory _$$_NetworkActivityInstanceCopyWith(_$_NetworkActivityInstance value,
          $Res Function(_$_NetworkActivityInstance) then) =
      __$$_NetworkActivityInstanceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @DateTimeConverter() @JsonKey(name: 'start_at') DateTime startAt,
      @DateTimeConverterNullable() @JsonKey(name: 'end_at') DateTime? endAt,
      String? comment,
      @JsonKey(name: 'activity_id') String activityId,
      @DateTimeConverterNullable() DateTime? createdAt});
}

/// @nodoc
class __$$_NetworkActivityInstanceCopyWithImpl<$Res>
    extends _$NetworkActivityInstanceCopyWithImpl<$Res,
        _$_NetworkActivityInstance>
    implements _$$_NetworkActivityInstanceCopyWith<$Res> {
  __$$_NetworkActivityInstanceCopyWithImpl(_$_NetworkActivityInstance _value,
      $Res Function(_$_NetworkActivityInstance) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? startAt = null,
    Object? endAt = freezed,
    Object? comment = freezed,
    Object? activityId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$_NetworkActivityInstance(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_NetworkActivityInstance extends _NetworkActivityInstance {
  const _$_NetworkActivityInstance(
      {this.id,
      @DateTimeConverter() @JsonKey(name: 'start_at') required this.startAt,
      @DateTimeConverterNullable() @JsonKey(name: 'end_at') this.endAt,
      this.comment,
      @JsonKey(name: 'activity_id') required this.activityId,
      @DateTimeConverterNullable() this.createdAt})
      : super._();

  factory _$_NetworkActivityInstance.fromJson(Map<String, dynamic> json) =>
      _$$_NetworkActivityInstanceFromJson(json);

  @override
  final String? id;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'start_at')
  final DateTime startAt;
  @override
  @DateTimeConverterNullable()
  @JsonKey(name: 'end_at')
  final DateTime? endAt;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'activity_id')
  final String activityId;
  @override
  @DateTimeConverterNullable()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'NetworkActivityInstance(id: $id, startAt: $startAt, endAt: $endAt, comment: $comment, activityId: $activityId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NetworkActivityInstance &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, startAt, endAt, comment, activityId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NetworkActivityInstanceCopyWith<_$_NetworkActivityInstance>
      get copyWith =>
          __$$_NetworkActivityInstanceCopyWithImpl<_$_NetworkActivityInstance>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NetworkActivityInstanceToJson(
      this,
    );
  }
}

abstract class _NetworkActivityInstance extends NetworkActivityInstance {
  const factory _NetworkActivityInstance(
          {final String? id,
          @DateTimeConverter()
          @JsonKey(name: 'start_at')
          required final DateTime startAt,
          @DateTimeConverterNullable()
          @JsonKey(name: 'end_at')
          final DateTime? endAt,
          final String? comment,
          @JsonKey(name: 'activity_id') required final String activityId,
          @DateTimeConverterNullable() final DateTime? createdAt}) =
      _$_NetworkActivityInstance;
  const _NetworkActivityInstance._() : super._();

  factory _NetworkActivityInstance.fromJson(Map<String, dynamic> json) =
      _$_NetworkActivityInstance.fromJson;

  @override
  String? get id;
  @override
  @DateTimeConverter()
  @JsonKey(name: 'start_at')
  DateTime get startAt;
  @override
  @DateTimeConverterNullable()
  @JsonKey(name: 'end_at')
  DateTime? get endAt;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'activity_id')
  String get activityId;
  @override
  @DateTimeConverterNullable()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_NetworkActivityInstanceCopyWith<_$_NetworkActivityInstance>
      get copyWith => throw _privateConstructorUsedError;
}
