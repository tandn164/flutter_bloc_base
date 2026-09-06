import 'service_catalog_item.dart';

abstract class ServiceCatalogRepository {
  Future<List<ServiceCatalogItem>> listItems({bool forceRefresh = false});
}
