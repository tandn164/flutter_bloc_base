// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_catalog_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCatalogItem {
  String get id;
  String get title;

  /// Create a copy of ServiceCatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServiceCatalogItemCopyWith<ServiceCatalogItem> get copyWith =>
      _$ServiceCatalogItemCopyWithImpl<ServiceCatalogItem>(
          this as ServiceCatalogItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServiceCatalogItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'ServiceCatalogItem(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class $ServiceCatalogItemCopyWith<$Res> {
  factory $ServiceCatalogItemCopyWith(
          ServiceCatalogItem value, $Res Function(ServiceCatalogItem) _then) =
      _$ServiceCatalogItemCopyWithImpl;
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class _$ServiceCatalogItemCopyWithImpl<$Res>
    implements $ServiceCatalogItemCopyWith<$Res> {
  _$ServiceCatalogItemCopyWithImpl(this._self, this._then);

  final ServiceCatalogItem _self;
  final $Res Function(ServiceCatalogItem) _then;

  /// Create a copy of ServiceCatalogItem
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

class _ServiceCatalogItem implements ServiceCatalogItem {
  const _ServiceCatalogItem({required this.id, required this.title});

  @override
  final String id;
  @override
  final String title;

  /// Create a copy of ServiceCatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ServiceCatalogItemCopyWith<_ServiceCatalogItem> get copyWith =>
      __$ServiceCatalogItemCopyWithImpl<_ServiceCatalogItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ServiceCatalogItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'ServiceCatalogItem(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class _$ServiceCatalogItemCopyWith<$Res>
    implements $ServiceCatalogItemCopyWith<$Res> {
  factory _$ServiceCatalogItemCopyWith(
          _ServiceCatalogItem value, $Res Function(_ServiceCatalogItem) _then) =
      __$ServiceCatalogItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class __$ServiceCatalogItemCopyWithImpl<$Res>
    implements _$ServiceCatalogItemCopyWith<$Res> {
  __$ServiceCatalogItemCopyWithImpl(this._self, this._then);

  final _ServiceCatalogItem _self;
  final $Res Function(_ServiceCatalogItem) _then;

  /// Create a copy of ServiceCatalogItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
  }) {
    return _then(_ServiceCatalogItem(
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
