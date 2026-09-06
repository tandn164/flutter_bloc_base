import 'service_catalog_item_dto.dart';

/// Implement with a Chopper service in a real app.
abstract interface class ServiceCatalogRemoteDataSource {
  Future<List<ServiceCatalogItemDto>> fetchCatalog();
}
