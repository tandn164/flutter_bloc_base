// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcements_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnouncementsItem {
  String get id;
  String get title;

  /// Create a copy of AnnouncementsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnnouncementsItemCopyWith<AnnouncementsItem> get copyWith =>
      _$AnnouncementsItemCopyWithImpl<AnnouncementsItem>(
          this as AnnouncementsItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnnouncementsItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'AnnouncementsItem(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class $AnnouncementsItemCopyWith<$Res> {
  factory $AnnouncementsItemCopyWith(
          AnnouncementsItem value, $Res Function(AnnouncementsItem) _then) =
      _$AnnouncementsItemCopyWithImpl;
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class _$AnnouncementsItemCopyWithImpl<$Res>
    implements $AnnouncementsItemCopyWith<$Res> {
  _$AnnouncementsItemCopyWithImpl(this._self, this._then);

  final AnnouncementsItem _self;
  final $Res Function(AnnouncementsItem) _then;

  /// Create a copy of AnnouncementsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
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
    ));
  }
}

/// @nodoc

class _AnnouncementsItem implements AnnouncementsItem {
  const _AnnouncementsItem({required this.id, required this.title});

  @override
  final String id;
  @override
  final String title;

  /// Create a copy of AnnouncementsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnnouncementsItemCopyWith<_AnnouncementsItem> get copyWith =>
      __$AnnouncementsItemCopyWithImpl<_AnnouncementsItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnnouncementsItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'AnnouncementsItem(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class _$AnnouncementsItemCopyWith<$Res>
    implements $AnnouncementsItemCopyWith<$Res> {
  factory _$AnnouncementsItemCopyWith(
          _AnnouncementsItem value, $Res Function(_AnnouncementsItem) _then) =
      __$AnnouncementsItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class __$AnnouncementsItemCopyWithImpl<$Res>
    implements _$AnnouncementsItemCopyWith<$Res> {
  __$AnnouncementsItemCopyWithImpl(this._self, this._then);

  final _AnnouncementsItem _self;
  final $Res Function(_AnnouncementsItem) _then;

  /// Create a copy of AnnouncementsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
  }) {
    return _then(_AnnouncementsItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
