import 'package:injectable/injectable.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';

@InjectableInit.microPackage(
    throwOnMissingDependencies: true,
    ignoreUnregisteredTypes: [ListServiceCatalogItems])
void initServiceCatalogPresentationModule() {}
