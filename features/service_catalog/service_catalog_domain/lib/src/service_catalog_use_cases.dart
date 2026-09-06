import 'package:injectable/injectable.dart';
import 'service_catalog_item.dart';
import 'service_catalog_repository.dart';

@lazySingleton
class ListServiceCatalogItems {
  const ListServiceCatalogItems(this.repository);

  final ServiceCatalogRepository repository;

  Future<List<ServiceCatalogItem>> call({bool forceRefresh = false}) =>
      repository.listItems(forceRefresh: forceRefresh);
}
