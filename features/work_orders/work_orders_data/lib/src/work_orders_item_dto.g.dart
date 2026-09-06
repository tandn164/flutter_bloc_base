// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_orders_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkOrdersItemDto _$WorkOrdersItemDtoFromJson(Map<String, dynamic> json) =>
    _WorkOrdersItemDto(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      pendingSync: json['pendingSync'] as bool? ?? false,
    );

Map<String, dynamic> _$WorkOrdersItemDtoToJson(_WorkOrdersItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
      'pendingSync': instance.pendingSync,
    };
