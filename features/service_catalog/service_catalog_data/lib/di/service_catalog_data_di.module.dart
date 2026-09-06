//@GeneratedMicroModule;ServiceCatalogDataPackageModule;package:service_catalog_data/di/service_catalog_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:service_catalog_data/src/service_catalog_remote_data_source.dart'
    as _i276;
import 'package:service_catalog_data/src/service_catalog_repository_impl.dart'
    as _i564;
import 'package:service_catalog_domain/service_catalog_domain.dart' as _i1017;

class ServiceCatalogDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i1017.ServiceCatalogRepository>(() =>
        _i564.ServiceCatalogRepositoryImpl.create(
            gh<_i276.ServiceCatalogRemoteDataSource>()));
  }
}
