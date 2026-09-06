import 'package:test/test.dart';
import 'package:work_orders_domain/work_orders_domain.dart';

class _Repository implements WorkOrdersRepository {
  @override
  Stream<List<WorkOrdersItem>> watchItems() => Stream.value(
        const [WorkOrdersItem(id: '1', title: 'Sample')],
      );
  @override
  Future<void> createItem(String title) async {}
  @override
  Future<void> setCompleted(String id, bool completed) async {}
  @override
  Future<void> synchronize() async {}
}

void main() {
  test('watch use case delegates', () async {
    final items = await ListWorkOrdersItems(_Repository())().first;
    expect(items.single.title, 'Sample');
  });
}
