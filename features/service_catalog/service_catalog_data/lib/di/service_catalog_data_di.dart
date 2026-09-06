import 'package:injectable/injectable.dart';
import '../src/service_catalog_remote_data_source.dart';

@InjectableInit.microPackage(
  throwOnMissingDependencies: true,
  ignoreUnregisteredTypes: [ServiceCatalogRemoteDataSource],
)
void initServiceCatalogDataModule() {}
