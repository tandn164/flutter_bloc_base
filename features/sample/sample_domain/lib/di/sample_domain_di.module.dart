//@GeneratedMicroModule;SampleDomainPackageModule;package:sample_domain/di/sample_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:sample_domain/src/repositories/sample_repository.dart' as _i875;
import 'package:sample_domain/src/usecases/get_sample.dart' as _i389;
import 'package:sample_domain/src/usecases/mutate_sample.dart' as _i1071;

class SampleDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i389.GetSample>(
        () => _i389.GetSample(gh<_i875.SampleRepository>()));
    gh.lazySingleton<_i1071.CreateSampleItem>(
        () => _i1071.CreateSampleItem(gh<_i875.SampleRepository>()));
    gh.lazySingleton<_i1071.UpdateSampleItem>(
        () => _i1071.UpdateSampleItem(gh<_i875.SampleRepository>()));
    gh.lazySingleton<_i1071.DeleteSampleItem>(
        () => _i1071.DeleteSampleItem(gh<_i875.SampleRepository>()));
  }
}
