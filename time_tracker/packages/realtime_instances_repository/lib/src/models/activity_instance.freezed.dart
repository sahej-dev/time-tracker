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

/// @nodoc
mixin _$ActivityInstance {
  String get id => throw _privateConstructorUsedError;
  DateTime get startAt => throw _privateConstructorUsedError;
  String get activityId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get endAt => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

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
      {String id,
      DateTime startAt,
      String activityId,
      DateTime createdAt,
      DateTime? endAt,
      String? comment});
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
    Object? id = null,
    Object? startAt = null,
    Object? activityId = null,
    Object? createdAt = null,
    Object? endAt = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String id,
      DateTime startAt,
      String activityId,
      DateTime createdAt,
      DateTime? endAt,
      String? comment});
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
    Object? id = null,
    Object? startAt = null,
    Object? activityId = null,
    Object? createdAt = null,
    Object? endAt = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$_ActivityInstance(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ActivityInstance extends _ActivityInstance {
  const _$_ActivityInstance(
      {required this.id,
      required this.startAt,
      required this.activityId,
      required this.createdAt,
      this.endAt,
      this.comment})
      : super._();

  @override
  final String id;
  @override
  final DateTime startAt;
  @override
  final String activityId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? endAt;
  @override
  final String? comment;

  @override
  String toString() {
    return 'ActivityInstance._def(id: $id, startAt: $startAt, activityId: $activityId, createdAt: $createdAt, endAt: $endAt, comment: $comment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityInstance &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, startAt, activityId, createdAt, endAt, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityInstanceCopyWith<_$_ActivityInstance> get copyWith =>
      __$$_ActivityInstanceCopyWithImpl<_$_ActivityInstance>(this, _$identity);
}

abstract class _ActivityInstance extends ActivityInstance {
  const factory _ActivityInstance(
      {required final String id,
      required final DateTime startAt,
      required final String activityId,
      required final DateTime createdAt,
      final DateTime? endAt,
      final String? comment}) = _$_ActivityInstance;
  const _ActivityInstance._() : super._();

  @override
  String get id;
  @override
  DateTime get startAt;
  @override
  String get activityId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get endAt;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityInstanceCopyWith<_$_ActivityInstance> get copyWith =>
      throw _privateConstructorUsedError;
}
