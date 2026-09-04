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
import 'package:sample_data/di/sample_data_di.module.dart' as _i223;
import 'package:sample_domain/di/sample_domain_di.module.dart' as _i17;
import 'package:sample_presentation/di/sample_presentation_di.module.dart'
    as _i791;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initSampleFeature({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i223.SampleDataPackageModule().init(gh);
    await _i17.SampleDomainPackageModule().init(gh);
    await _i791.SamplePresentationPackageModule().init(gh);
    return this;
  }
}
