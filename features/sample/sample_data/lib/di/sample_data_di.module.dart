//@GeneratedMicroModule;SampleDataPackageModule;package:sample_data/di/sample_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:chopper/chopper.dart' as _i31;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sample_data/src/api/sample_api.dart' as _i1052;
import 'package:sample_data/src/repositories/local_sample_repository.dart'
    as _i456;
import 'package:sample_data/src/repositories/sample_repository_impl.dart'
    as _i568;

class SampleDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i456.LocalSampleRepository>(
        () => _i456.LocalSampleRepository.create());
    gh.lazySingleton<_i1052.SampleApi>(
        () => _i1052.SampleApi.createForDi(gh<_i31.ChopperClient>()));
    gh.lazySingleton<_i568.SampleRepositoryImpl>(
        () => _i568.SampleRepositoryImpl.create(gh<_i1052.SampleApi>()));
  }
}
