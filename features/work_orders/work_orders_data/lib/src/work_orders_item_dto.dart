import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

part 'work_orders_item_dto.freezed.dart';
part 'work_orders_item_dto.g.dart';

@freezed
abstract class WorkOrdersItemDto with _$WorkOrdersItemDto {
  const WorkOrdersItemDto._();
  const factory WorkOrdersItemDto({
    required String id,
    required String title,
    @Default(false) bool completed,
    @Default(false) bool pendingSync,
  }) = _WorkOrdersItemDto;
  factory WorkOrdersItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrdersItemDtoFromJson(json);
  WorkOrdersItem toEntity() => WorkOrdersItem(
        id: id,
        title: title,
        completed: completed,
        pendingSync: pendingSync,
      );

  static List<WorkOrdersItemDto> listFromJson(String source) => [
        for (final item in jsonDecode(source) as List)
          WorkOrdersItemDto.fromJson(Map<String, dynamic>.from(item as Map)),
      ];

  static String listToJson(Iterable<WorkOrdersItemDto> items) =>
      jsonEncode([for (final item in items) item.toJson()]);
}
