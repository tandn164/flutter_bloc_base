import 'package:service_catalog_domain/service_catalog_domain.dart';
import 'package:test/test.dart';

class _Repository implements ServiceCatalogRepository {
  @override
  Future<List<ServiceCatalogItem>> listItems(
          {bool forceRefresh = false}) async =>
      const [ServiceCatalogItem(id: '1', title: 'Sample')];
}

void main() {
  test('use case delegates; generated equality and copyWith work', () async {
    final items = await ListServiceCatalogItems(_Repository())();
    expect(items.single.copyWith(title: 'Changed'),
        const ServiceCatalogItem(id: '1', title: 'Changed'));
  });
}
