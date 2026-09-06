import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:service_catalog_data/di/service_catalog_data_di.module.dart';
import 'package:service_catalog_domain/di/service_catalog_domain_di.module.dart';
import 'package:service_catalog_presentation/di/service_catalog_presentation_di.module.dart';

import 'service_catalog_di.config.dart';

@InjectableInit(
  initializerName: 'initServiceCatalogFeature',
  generateForDir: ['lib/app/features/service_catalog'],
  includeMicroPackages: false,
  externalPackageModulesBefore: [
    ExternalModule(ServiceCatalogDataPackageModule),
    ExternalModule(ServiceCatalogDomainPackageModule),
    ExternalModule(ServiceCatalogPresentationPackageModule),
  ],
)
Future<void> registerServiceCatalogDependencies(GetIt container) =>
    container.initServiceCatalogFeature();
