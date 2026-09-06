import 'package:injectable/injectable.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';

import 'service_catalog_remote_data_source.dart';

@LazySingleton(as: ServiceCatalogRepository)
class ServiceCatalogRepositoryImpl implements ServiceCatalogRepository {
  ServiceCatalogRepositoryImpl(this._remote);

  @factoryMethod
  static ServiceCatalogRepositoryImpl create(
    ServiceCatalogRemoteDataSource remote,
  ) =>
      ServiceCatalogRepositoryImpl(remote);

  final ServiceCatalogRemoteDataSource _remote;

  @override
  Future<List<ServiceCatalogItem>> listItems(
      {bool forceRefresh = false}) async {
    return [for (final dto in await _remote.fetchCatalog()) dto.toEntity()];
  }
}
