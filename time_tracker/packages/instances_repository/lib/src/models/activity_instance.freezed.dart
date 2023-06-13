// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActivityInstance _$ActivityInstanceFromJson(Map<String, dynamic> json) {
  return _ActivityInstance.fromJson(json);
}

/// @nodoc
mixin _$ActivityInstance {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at')
  DateTime get startAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_at')
  DateTime? get endAt => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  String get activityId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityInstanceCopyWith<ActivityInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityInstanceCopyWith<$Res> {
  factory $ActivityInstanceCopyWith(
          ActivityInstance value, $Res Function(ActivityInstance) then) =
      _$ActivityInstanceCopyWithImpl<$Res, ActivityInstance>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'start_at') DateTime startAt,
      @JsonKey(name: 'end_at') DateTime? endAt,
      String? comment,
      @JsonKey(name: 'activity_id') String activityId,
      DateTime? createdAt});
}

/// @nodoc
class _$ActivityInstanceCopyWithImpl<$Res, $Val extends ActivityInstance>
    implements $ActivityInstanceCopyWith<$Res> {
  _$ActivityInstanceCopyWithImpl(this._value, this._then);

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
abstract class _$$_ActivityInstanceCopyWith<$Res>
    implements $ActivityInstanceCopyWith<$Res> {
  factory _$$_ActivityInstanceCopyWith(
          _$_ActivityInstance value, $Res Function(_$_ActivityInstance) then) =
      __$$_ActivityInstanceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'start_at') DateTime startAt,
      @JsonKey(name: 'end_at') DateTime? endAt,
      String? comment,
      @JsonKey(name: 'activity_id') String activityId,
      DateTime? createdAt});
}

/// @nodoc
class __$$_ActivityInstanceCopyWithImpl<$Res>
    extends _$ActivityInstanceCopyWithImpl<$Res, _$_ActivityInstance>
    implements _$$_ActivityInstanceCopyWith<$Res> {
  __$$_ActivityInstanceCopyWithImpl(
      _$_ActivityInstance _value, $Res Function(_$_ActivityInstance) _then)
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
    return _then(_$_ActivityInstance(
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
class _$_ActivityInstance implements _ActivityInstance {
  const _$_ActivityInstance(
      {this.id,
      @JsonKey(name: 'start_at') required this.startAt,
      @JsonKey(name: 'end_at') this.endAt,
      this.comment,
      @JsonKey(name: 'activity_id') required this.activityId,
      this.createdAt});

  factory _$_ActivityInstance.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityInstanceFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'start_at')
  final DateTime startAt;
  @override
  @JsonKey(name: 'end_at')
  final DateTime? endAt;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'activity_id')
  final String activityId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ActivityInstance(id: $id, startAt: $startAt, endAt: $endAt, comment: $comment, activityId: $activityId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityInstance &&
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
  _$$_ActivityInstanceCopyWith<_$_ActivityInstance> get copyWith =>
      __$$_ActivityInstanceCopyWithImpl<_$_ActivityInstance>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityInstanceToJson(
      this,
    );
  }
}

abstract class _ActivityInstance implements ActivityInstance {
  const factory _ActivityInstance(
      {final String? id,
      @JsonKey(name: 'start_at') required final DateTime startAt,
      @JsonKey(name: 'end_at') final DateTime? endAt,
      final String? comment,
      @JsonKey(name: 'activity_id') required final String activityId,
      final DateTime? createdAt}) = _$_ActivityInstance;

  factory _ActivityInstance.fromJson(Map<String, dynamic> json) =
      _$_ActivityInstance.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'start_at')
  DateTime get startAt;
  @override
  @JsonKey(name: 'end_at')
  DateTime? get endAt;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'activity_id')
  String get activityId;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityInstanceCopyWith<_$_ActivityInstance> get copyWith =>
      throw _privateConstructorUsedError;
}
