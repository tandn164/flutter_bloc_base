import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';
import 'package:service_catalog_presentation/service_catalog_presentation.dart';

class _Repository implements ServiceCatalogRepository {
  @override
  Future<List<ServiceCatalogItem>> listItems(
          {bool forceRefresh = false}) async =>
      const [ServiceCatalogItem(id: '1', title: 'Loaded item')];
}

void main() {
  testWidgets('UI loads items through BLoC and use case', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ServiceCatalogPage(
      createBloc: () =>
          ServiceCatalogBloc(ListServiceCatalogItems(_Repository())),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Loaded item'), findsOneWidget);
  });
}
