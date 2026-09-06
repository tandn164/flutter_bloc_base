// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcements_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnouncementsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AnnouncementsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AnnouncementsState()';
  }
}

/// @nodoc
class $AnnouncementsStateCopyWith<$Res> {
  $AnnouncementsStateCopyWith(
      AnnouncementsState _, $Res Function(AnnouncementsState) __);
}

/// @nodoc

class AnnouncementsLoading implements AnnouncementsState {
  const AnnouncementsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AnnouncementsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AnnouncementsState.loading()';
  }
}

/// @nodoc

class AnnouncementsData implements AnnouncementsState {
  const AnnouncementsData(final List<AnnouncementsItem> items) : _items = items;

  final List<AnnouncementsItem> _items;
  List<AnnouncementsItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of AnnouncementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnnouncementsDataCopyWith<AnnouncementsData> get copyWith =>
      _$AnnouncementsDataCopyWithImpl<AnnouncementsData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnnouncementsData &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'AnnouncementsState.data(items: $items)';
  }
}

/// @nodoc
abstract mixin class $AnnouncementsDataCopyWith<$Res>
    implements $AnnouncementsStateCopyWith<$Res> {
  factory $AnnouncementsDataCopyWith(
          AnnouncementsData value, $Res Function(AnnouncementsData) _then) =
      _$AnnouncementsDataCopyWithImpl;
  @useResult
  $Res call({List<AnnouncementsItem> items});
}

/// @nodoc
class _$AnnouncementsDataCopyWithImpl<$Res>
    implements $AnnouncementsDataCopyWith<$Res> {
  _$AnnouncementsDataCopyWithImpl(this._self, this._then);

  final AnnouncementsData _self;
  final $Res Function(AnnouncementsData) _then;

  /// Create a copy of AnnouncementsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(AnnouncementsData(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AnnouncementsItem>,
    ));
  }
}

/// @nodoc

class AnnouncementsError implements AnnouncementsState {
  const AnnouncementsError(this.message);

  final String message;

  /// Create a copy of AnnouncementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnnouncementsErrorCopyWith<AnnouncementsError> get copyWith =>
      _$AnnouncementsErrorCopyWithImpl<AnnouncementsError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnnouncementsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AnnouncementsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AnnouncementsErrorCopyWith<$Res>
    implements $AnnouncementsStateCopyWith<$Res> {
  factory $AnnouncementsErrorCopyWith(
          AnnouncementsError value, $Res Function(AnnouncementsError) _then) =
      _$AnnouncementsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AnnouncementsErrorCopyWithImpl<$Res>
    implements $AnnouncementsErrorCopyWith<$Res> {
  _$AnnouncementsErrorCopyWithImpl(this._self, this._then);

  final AnnouncementsError _self;
  final $Res Function(AnnouncementsError) _then;

  /// Create a copy of AnnouncementsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AnnouncementsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
