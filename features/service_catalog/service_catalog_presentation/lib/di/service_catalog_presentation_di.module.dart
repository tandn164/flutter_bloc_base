//@GeneratedMicroModule;ServiceCatalogPresentationPackageModule;package:service_catalog_presentation/di/service_catalog_presentation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:service_catalog_domain/service_catalog_domain.dart' as _i1017;
import 'package:service_catalog_presentation/src/service_catalog_bloc.dart'
    as _i391;

class ServiceCatalogPresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i391.ServiceCatalogBloc>(
        () => _i391.ServiceCatalogBloc(gh<_i1017.ListServiceCatalogItems>()));
  }
}
