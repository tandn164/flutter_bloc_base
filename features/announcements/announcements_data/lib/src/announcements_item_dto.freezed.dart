// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcements_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnouncementsItemDto {
  String get id;
  String get title;

  /// Create a copy of AnnouncementsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnnouncementsItemDtoCopyWith<AnnouncementsItemDto> get copyWith =>
      _$AnnouncementsItemDtoCopyWithImpl<AnnouncementsItemDto>(
          this as AnnouncementsItemDto, _$identity);

  /// Serializes this AnnouncementsItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnnouncementsItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'AnnouncementsItemDto(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class $AnnouncementsItemDtoCopyWith<$Res> {
  factory $AnnouncementsItemDtoCopyWith(AnnouncementsItemDto value,
          $Res Function(AnnouncementsItemDto) _then) =
      _$AnnouncementsItemDtoCopyWithImpl;
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class _$AnnouncementsItemDtoCopyWithImpl<$Res>
    implements $AnnouncementsItemDtoCopyWith<$Res> {
  _$AnnouncementsItemDtoCopyWithImpl(this._self, this._then);

  final AnnouncementsItemDto _self;
  final $Res Function(AnnouncementsItemDto) _then;

  /// Create a copy of AnnouncementsItemDto
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
class _AnnouncementsItemDto extends AnnouncementsItemDto {
  const _AnnouncementsItemDto({required this.id, required this.title})
      : super._();
  factory _AnnouncementsItemDto.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementsItemDtoFromJson(json);

  @override
  final String id;
  @override
  final String title;

  /// Create a copy of AnnouncementsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnnouncementsItemDtoCopyWith<_AnnouncementsItemDto> get copyWith =>
      __$AnnouncementsItemDtoCopyWithImpl<_AnnouncementsItemDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AnnouncementsItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnnouncementsItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'AnnouncementsItemDto(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class _$AnnouncementsItemDtoCopyWith<$Res>
    implements $AnnouncementsItemDtoCopyWith<$Res> {
  factory _$AnnouncementsItemDtoCopyWith(_AnnouncementsItemDto value,
          $Res Function(_AnnouncementsItemDto) _then) =
      __$AnnouncementsItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class __$AnnouncementsItemDtoCopyWithImpl<$Res>
    implements _$AnnouncementsItemDtoCopyWith<$Res> {
  __$AnnouncementsItemDtoCopyWithImpl(this._self, this._then);

  final _AnnouncementsItemDto _self;
  final $Res Function(_AnnouncementsItemDto) _then;

  /// Create a copy of AnnouncementsItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
  }) {
    return _then(_AnnouncementsItemDto(
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
