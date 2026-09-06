// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_catalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCatalogState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ServiceCatalogState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ServiceCatalogState()';
  }
}

/// @nodoc
class $ServiceCatalogStateCopyWith<$Res> {
  $ServiceCatalogStateCopyWith(
      ServiceCatalogState _, $Res Function(ServiceCatalogState) __);
}

/// @nodoc

class ServiceCatalogLoading implements ServiceCatalogState {
  const ServiceCatalogLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ServiceCatalogLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ServiceCatalogState.loading()';
  }
}

/// @nodoc

class ServiceCatalogData implements ServiceCatalogState {
  const ServiceCatalogData(final List<ServiceCatalogItem> items)
      : _items = items;

  final List<ServiceCatalogItem> _items;
  List<ServiceCatalogItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of ServiceCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServiceCatalogDataCopyWith<ServiceCatalogData> get copyWith =>
      _$ServiceCatalogDataCopyWithImpl<ServiceCatalogData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServiceCatalogData &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'ServiceCatalogState.data(items: $items)';
  }
}

/// @nodoc
abstract mixin class $ServiceCatalogDataCopyWith<$Res>
    implements $ServiceCatalogStateCopyWith<$Res> {
  factory $ServiceCatalogDataCopyWith(
          ServiceCatalogData value, $Res Function(ServiceCatalogData) _then) =
      _$ServiceCatalogDataCopyWithImpl;
  @useResult
  $Res call({List<ServiceCatalogItem> items});
}

/// @nodoc
class _$ServiceCatalogDataCopyWithImpl<$Res>
    implements $ServiceCatalogDataCopyWith<$Res> {
  _$ServiceCatalogDataCopyWithImpl(this._self, this._then);

  final ServiceCatalogData _self;
  final $Res Function(ServiceCatalogData) _then;

  /// Create a copy of ServiceCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(ServiceCatalogData(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ServiceCatalogItem>,
    ));
  }
}

/// @nodoc

class ServiceCatalogError implements ServiceCatalogState {
  const ServiceCatalogError(this.message);

  final String message;

  /// Create a copy of ServiceCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServiceCatalogErrorCopyWith<ServiceCatalogError> get copyWith =>
      _$ServiceCatalogErrorCopyWithImpl<ServiceCatalogError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServiceCatalogError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ServiceCatalogState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ServiceCatalogErrorCopyWith<$Res>
    implements $ServiceCatalogStateCopyWith<$Res> {
  factory $ServiceCatalogErrorCopyWith(
          ServiceCatalogError value, $Res Function(ServiceCatalogError) _then) =
      _$ServiceCatalogErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ServiceCatalogErrorCopyWithImpl<$Res>
    implements $ServiceCatalogErrorCopyWith<$Res> {
  _$ServiceCatalogErrorCopyWithImpl(this._self, this._then);

  final ServiceCatalogError _self;
  final $Res Function(ServiceCatalogError) _then;

  /// Create a copy of ServiceCatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ServiceCatalogError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
