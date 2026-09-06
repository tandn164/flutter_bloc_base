import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_orders_item.freezed.dart';

@freezed
abstract class WorkOrdersItem with _$WorkOrdersItem {
  const factory WorkOrdersItem({
    required String id,
    required String title,
    @Default(false) bool completed,
    @Default(false) bool pendingSync,
  }) = _WorkOrdersItem;
}
