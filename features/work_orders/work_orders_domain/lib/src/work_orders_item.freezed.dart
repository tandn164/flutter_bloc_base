// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_orders_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkOrdersItem {
  String get id;
  String get title;
  bool get completed;
  bool get pendingSync;

  /// Create a copy of WorkOrdersItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkOrdersItemCopyWith<WorkOrdersItem> get copyWith =>
      _$WorkOrdersItemCopyWithImpl<WorkOrdersItem>(
          this as WorkOrdersItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkOrdersItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.pendingSync, pendingSync) ||
                other.pendingSync == pendingSync));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, completed, pendingSync);

  @override
  String toString() {
    return 'WorkOrdersItem(id: $id, title: $title, completed: $completed, pendingSync: $pendingSync)';
  }
}

/// @nodoc
abstract mixin class $WorkOrdersItemCopyWith<$Res> {
  factory $WorkOrdersItemCopyWith(
          WorkOrdersItem value, $Res Function(WorkOrdersItem) _then) =
      _$WorkOrdersItemCopyWithImpl;
  @useResult
  $Res call({String id, String title, bool completed, bool pendingSync});
}

/// @nodoc
class _$WorkOrdersItemCopyWithImpl<$Res>
    implements $WorkOrdersItemCopyWith<$Res> {
  _$WorkOrdersItemCopyWithImpl(this._self, this._then);

  final WorkOrdersItem _self;
  final $Res Function(WorkOrdersItem) _then;

  /// Create a copy of WorkOrdersItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? pendingSync = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingSync: null == pendingSync
          ? _self.pendingSync
          : pendingSync // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _WorkOrdersItem implements WorkOrdersItem {
  const _WorkOrdersItem(
      {required this.id,
      required this.title,
      this.completed = false,
      this.pendingSync = false});

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final bool pendingSync;

  /// Create a copy of WorkOrdersItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkOrdersItemCopyWith<_WorkOrdersItem> get copyWith =>
      __$WorkOrdersItemCopyWithImpl<_WorkOrdersItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkOrdersItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.pendingSync, pendingSync) ||
                other.pendingSync == pendingSync));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, completed, pendingSync);

  @override
  String toString() {
    return 'WorkOrdersItem(id: $id, title: $title, completed: $completed, pendingSync: $pendingSync)';
  }
}

/// @nodoc
abstract mixin class _$WorkOrdersItemCopyWith<$Res>
    implements $WorkOrdersItemCopyWith<$Res> {
  factory _$WorkOrdersItemCopyWith(
          _WorkOrdersItem value, $Res Function(_WorkOrdersItem) _then) =
      __$WorkOrdersItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, bool completed, bool pendingSync});
}

/// @nodoc
class __$WorkOrdersItemCopyWithImpl<$Res>
    implements _$WorkOrdersItemCopyWith<$Res> {
  __$WorkOrdersItemCopyWithImpl(this._self, this._then);

  final _WorkOrdersItem _self;
  final $Res Function(_WorkOrdersItem) _then;

  /// Create a copy of WorkOrdersItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? pendingSync = null,
  }) {
    return _then(_WorkOrdersItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingSync: null == pendingSync
          ? _self.pendingSync
          : pendingSync // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
