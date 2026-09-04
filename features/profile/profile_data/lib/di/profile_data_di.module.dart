//@GeneratedMicroModule;ProfileDataPackageModule;package:profile_data/di/profile_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:chopper/chopper.dart' as _i31;
import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_data/src/api/profile_api.dart' as _i890;
import 'package:profile_data/src/datasources/profile_network_ds.dart' as _i293;
import 'package:profile_data/src/repositories/profile_repository_impl.dart'
    as _i975;
import 'package:profile_domain/profile_domain.dart' as _i952;

const String _remote = 'remote';

class ProfileDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i890.ProfileApi>(
      () => _i890.ProfileApi.createForDi(gh<_i31.ChopperClient>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i293.ProfileNetworkDs>(
      () => _i293.ProfileNetworkDs(gh<_i890.ProfileApi>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i952.ProfileRepository>(
      () =>
          _i975.ProfileRepositoryImpl.fromNetwork(gh<_i293.ProfileNetworkDs>()),
      registerFor: {_remote},
    );
  }
}
