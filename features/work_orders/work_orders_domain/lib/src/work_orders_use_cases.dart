import 'package:injectable/injectable.dart';
import 'work_orders_item.dart';
import 'work_orders_repository.dart';

@lazySingleton
class ListWorkOrdersItems {
  const ListWorkOrdersItems(this.repository);

  final WorkOrdersRepository repository;

  Stream<List<WorkOrdersItem>> call() => repository.watchItems();
}

@lazySingleton
class SynchronizeWorkOrders {
  const SynchronizeWorkOrders(this.repository);
  final WorkOrdersRepository repository;
  Future<void> call() => repository.synchronize();
}

@lazySingleton
class CreateWorkOrder {
  const CreateWorkOrder(this.repository);
  final WorkOrdersRepository repository;
  Future<void> call(String title) => repository.createItem(title);
}

@lazySingleton
class SetWorkOrderCompleted {
  const SetWorkOrderCompleted(this.repository);
  final WorkOrdersRepository repository;
  Future<void> call(String id, bool completed) =>
      repository.setCompleted(id, completed);
}
