// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:service_catalog_data/di/service_catalog_data_di.module.dart'
    as _i341;
import 'package:service_catalog_domain/di/service_catalog_domain_di.module.dart'
    as _i274;
import 'package:service_catalog_presentation/di/service_catalog_presentation_di.module.dart'
    as _i750;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initServiceCatalogFeature({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i341.ServiceCatalogDataPackageModule().init(gh);
    await _i274.ServiceCatalogDomainPackageModule().init(gh);
    await _i750.ServiceCatalogPresentationPackageModule().init(gh);
    return this;
  }
}
