//@GeneratedMicroModule;ServiceCatalogDomainPackageModule;package:service_catalog_domain/di/service_catalog_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:service_catalog_domain/src/service_catalog_repository.dart'
    as _i807;
import 'package:service_catalog_domain/src/service_catalog_use_cases.dart'
    as _i449;

class ServiceCatalogDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i449.ListServiceCatalogItems>(() =>
        _i449.ListServiceCatalogItems(gh<_i807.ServiceCatalogRepository>()));
  }
}
