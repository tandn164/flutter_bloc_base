// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_orders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkOrdersState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WorkOrdersState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WorkOrdersState()';
  }
}

/// @nodoc
class $WorkOrdersStateCopyWith<$Res> {
  $WorkOrdersStateCopyWith(
      WorkOrdersState _, $Res Function(WorkOrdersState) __);
}

/// @nodoc

class WorkOrdersLoading implements WorkOrdersState {
  const WorkOrdersLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WorkOrdersLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WorkOrdersState.loading()';
  }
}

/// @nodoc

class WorkOrdersData implements WorkOrdersState {
  const WorkOrdersData(final List<WorkOrdersItem> items) : _items = items;

  final List<WorkOrdersItem> _items;
  List<WorkOrdersItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of WorkOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkOrdersDataCopyWith<WorkOrdersData> get copyWith =>
      _$WorkOrdersDataCopyWithImpl<WorkOrdersData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkOrdersData &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'WorkOrdersState.data(items: $items)';
  }
}

/// @nodoc
abstract mixin class $WorkOrdersDataCopyWith<$Res>
    implements $WorkOrdersStateCopyWith<$Res> {
  factory $WorkOrdersDataCopyWith(
          WorkOrdersData value, $Res Function(WorkOrdersData) _then) =
      _$WorkOrdersDataCopyWithImpl;
  @useResult
  $Res call({List<WorkOrdersItem> items});
}

/// @nodoc
class _$WorkOrdersDataCopyWithImpl<$Res>
    implements $WorkOrdersDataCopyWith<$Res> {
  _$WorkOrdersDataCopyWithImpl(this._self, this._then);

  final WorkOrdersData _self;
  final $Res Function(WorkOrdersData) _then;

  /// Create a copy of WorkOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(WorkOrdersData(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WorkOrdersItem>,
    ));
  }
}

/// @nodoc

class WorkOrdersError implements WorkOrdersState {
  const WorkOrdersError(this.message);

  final String message;

  /// Create a copy of WorkOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkOrdersErrorCopyWith<WorkOrdersError> get copyWith =>
      _$WorkOrdersErrorCopyWithImpl<WorkOrdersError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkOrdersError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'WorkOrdersState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $WorkOrdersErrorCopyWith<$Res>
    implements $WorkOrdersStateCopyWith<$Res> {
  factory $WorkOrdersErrorCopyWith(
          WorkOrdersError value, $Res Function(WorkOrdersError) _then) =
      _$WorkOrdersErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$WorkOrdersErrorCopyWithImpl<$Res>
    implements $WorkOrdersErrorCopyWith<$Res> {
  _$WorkOrdersErrorCopyWithImpl(this._self, this._then);

  final WorkOrdersError _self;
  final $Res Function(WorkOrdersError) _then;

  /// Create a copy of WorkOrdersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(WorkOrdersError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
