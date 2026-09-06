// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_catalog_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceCatalogItemDto {
  String get id;
  String get title;

  /// Create a copy of ServiceCatalogItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServiceCatalogItemDtoCopyWith<ServiceCatalogItemDto> get copyWith =>
      _$ServiceCatalogItemDtoCopyWithImpl<ServiceCatalogItemDto>(
          this as ServiceCatalogItemDto, _$identity);

  /// Serializes this ServiceCatalogItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServiceCatalogItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'ServiceCatalogItemDto(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class $ServiceCatalogItemDtoCopyWith<$Res> {
  factory $ServiceCatalogItemDtoCopyWith(ServiceCatalogItemDto value,
          $Res Function(ServiceCatalogItemDto) _then) =
      _$ServiceCatalogItemDtoCopyWithImpl;
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class _$ServiceCatalogItemDtoCopyWithImpl<$Res>
    implements $ServiceCatalogItemDtoCopyWith<$Res> {
  _$ServiceCatalogItemDtoCopyWithImpl(this._self, this._then);

  final ServiceCatalogItemDto _self;
  final $Res Function(ServiceCatalogItemDto) _then;

  /// Create a copy of ServiceCatalogItemDto
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
@JsonSerializable()
class _ServiceCatalogItemDto extends ServiceCatalogItemDto {
  const _ServiceCatalogItemDto({required this.id, required this.title})
      : super._();
  factory _ServiceCatalogItemDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceCatalogItemDtoFromJson(json);

  @override
  final String id;
  @override
  final String title;

  /// Create a copy of ServiceCatalogItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ServiceCatalogItemDtoCopyWith<_ServiceCatalogItemDto> get copyWith =>
      __$ServiceCatalogItemDtoCopyWithImpl<_ServiceCatalogItemDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ServiceCatalogItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ServiceCatalogItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'ServiceCatalogItemDto(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class _$ServiceCatalogItemDtoCopyWith<$Res>
    implements $ServiceCatalogItemDtoCopyWith<$Res> {
  factory _$ServiceCatalogItemDtoCopyWith(_ServiceCatalogItemDto value,
          $Res Function(_ServiceCatalogItemDto) _then) =
      __$ServiceCatalogItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class __$ServiceCatalogItemDtoCopyWithImpl<$Res>
    implements _$ServiceCatalogItemDtoCopyWith<$Res> {
  __$ServiceCatalogItemDtoCopyWithImpl(this._self, this._then);

  final _ServiceCatalogItemDto _self;
  final $Res Function(_ServiceCatalogItemDto) _then;

  /// Create a copy of ServiceCatalogItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
  }) {
    return _then(_ServiceCatalogItemDto(
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
