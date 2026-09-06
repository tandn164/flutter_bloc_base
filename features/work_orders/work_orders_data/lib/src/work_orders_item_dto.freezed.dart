// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_orders_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkOrdersItemDto {
  String get id;
  String get title;
  bool get completed;
  bool get pendingSync;

  /// Create a copy of WorkOrdersItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkOrdersItemDtoCopyWith<WorkOrdersItemDto> get copyWith =>
      _$WorkOrdersItemDtoCopyWithImpl<WorkOrdersItemDto>(
          this as WorkOrdersItemDto, _$identity);

  /// Serializes this WorkOrdersItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkOrdersItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.pendingSync, pendingSync) ||
                other.pendingSync == pendingSync));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, completed, pendingSync);

  @override
  String toString() {
    return 'WorkOrdersItemDto(id: $id, title: $title, completed: $completed, pendingSync: $pendingSync)';
  }
}

/// @nodoc
abstract mixin class $WorkOrdersItemDtoCopyWith<$Res> {
  factory $WorkOrdersItemDtoCopyWith(
          WorkOrdersItemDto value, $Res Function(WorkOrdersItemDto) _then) =
      _$WorkOrdersItemDtoCopyWithImpl;
  @useResult
  $Res call({String id, String title, bool completed, bool pendingSync});
}

/// @nodoc
class _$WorkOrdersItemDtoCopyWithImpl<$Res>
    implements $WorkOrdersItemDtoCopyWith<$Res> {
  _$WorkOrdersItemDtoCopyWithImpl(this._self, this._then);

  final WorkOrdersItemDto _self;
  final $Res Function(WorkOrdersItemDto) _then;

  /// Create a copy of WorkOrdersItemDto
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
@JsonSerializable()
class _WorkOrdersItemDto extends WorkOrdersItemDto {
  const _WorkOrdersItemDto(
      {required this.id,
      required this.title,
      this.completed = false,
      this.pendingSync = false})
      : super._();
  factory _WorkOrdersItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrdersItemDtoFromJson(json);

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

  /// Create a copy of WorkOrdersItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkOrdersItemDtoCopyWith<_WorkOrdersItemDto> get copyWith =>
      __$WorkOrdersItemDtoCopyWithImpl<_WorkOrdersItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkOrdersItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkOrdersItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.pendingSync, pendingSync) ||
                other.pendingSync == pendingSync));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, completed, pendingSync);

  @override
  String toString() {
    return 'WorkOrdersItemDto(id: $id, title: $title, completed: $completed, pendingSync: $pendingSync)';
  }
}

/// @nodoc
abstract mixin class _$WorkOrdersItemDtoCopyWith<$Res>
    implements $WorkOrdersItemDtoCopyWith<$Res> {
  factory _$WorkOrdersItemDtoCopyWith(
          _WorkOrdersItemDto value, $Res Function(_WorkOrdersItemDto) _then) =
      __$WorkOrdersItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, bool completed, bool pendingSync});
}

/// @nodoc
class __$WorkOrdersItemDtoCopyWithImpl<$Res>
    implements _$WorkOrdersItemDtoCopyWith<$Res> {
  __$WorkOrdersItemDtoCopyWithImpl(this._self, this._then);

  final _WorkOrdersItemDto _self;
  final $Res Function(_WorkOrdersItemDto) _then;

  /// Create a copy of WorkOrdersItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? pendingSync = null,
  }) {
    return _then(_WorkOrdersItemDto(
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
