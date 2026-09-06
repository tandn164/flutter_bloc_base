import 'package:service_catalog_data/service_catalog_data.dart';
import 'package:test/test.dart';

class _Remote implements ServiceCatalogRemoteDataSource {
  var calls = 0;
  @override
  Future<List<ServiceCatalogItemDto>> fetchCatalog() async {
    calls++;
    return const [ServiceCatalogItemDto(id: '1', title: 'Inspection')];
  }
}

void main() {
  test('always reads from remote because this feature has no cache', () async {
    final remote = _Remote();
    final repository = ServiceCatalogRepositoryImpl(remote);
    await repository.listItems();
    await repository.listItems();
    expect(remote.calls, 2);
  });
}
