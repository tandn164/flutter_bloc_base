//@GeneratedMicroModule;SampleDataPackageModule;package:sample_data/di/sample_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:api_client/api_client.dart' as _i633;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sample_data/src/repositories/local_sample_repository.dart'
    as _i456;
import 'package:sample_data/src/repositories/sample_repository_impl.dart'
    as _i568;
import 'package:sample_domain/sample_domain.dart' as _i180;

const String _local = 'local';
const String _remote = 'remote';

class SampleDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i180.SampleRepository>(
      () => _i456.LocalSampleRepository.create(),
      registerFor: {_local},
    );
    gh.lazySingleton<_i180.SampleRepository>(
      () => _i568.SampleRepositoryImpl.create(gh<_i633.DataGateway>()),
      registerFor: {_remote},
    );
  }
}
