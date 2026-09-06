import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_orders_domain/work_orders_domain.dart';
import 'package:work_orders_presentation/work_orders_presentation.dart';

class _Repository implements WorkOrdersRepository {
  @override
  Stream<List<WorkOrdersItem>> watchItems() => Stream.value(
        const [WorkOrdersItem(id: '1', title: 'Loaded item')],
      );
  @override
  Future<void> createItem(String title) async {}
  @override
  Future<void> setCompleted(String id, bool completed) async {}
  @override
  Future<void> synchronize() async {}
}

void main() {
  testWidgets('renders local stream', (tester) async {
    final repository = _Repository();
    await tester.pumpWidget(MaterialApp(
      home: WorkOrdersPage(
        createBloc: () => WorkOrdersBloc(
          ListWorkOrdersItems(repository),
          SynchronizeWorkOrders(repository),
          CreateWorkOrder(repository),
          SetWorkOrderCompleted(repository),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Loaded item'), findsOneWidget);
  });
}
