import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

part 'work_orders_state.freezed.dart';

@freezed
sealed class WorkOrdersState with _$WorkOrdersState {
  const factory WorkOrdersState.loading() = WorkOrdersLoading;
  const factory WorkOrdersState.data(List<WorkOrdersItem> items) =
      WorkOrdersData;
  const factory WorkOrdersState.error(String message) = WorkOrdersError;
}
