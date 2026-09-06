import 'work_orders_item.dart';

abstract class WorkOrdersRepository {
  Stream<List<WorkOrdersItem>> watchItems();
  Future<void> synchronize();
  Future<void> createItem(String title);
  Future<void> setCompleted(String id, bool completed);
}
