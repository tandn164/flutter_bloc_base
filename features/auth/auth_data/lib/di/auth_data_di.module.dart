//@GeneratedMicroModule;AuthDataPackageModule;package:auth_data/di/auth_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:api_client/api_client.dart' as _i633;
import 'package:app_session/app_session.dart' as _i353;
import 'package:auth_data/src/api/auth_api.dart' as _i449;
import 'package:auth_data/src/datasources/auth_network_ds.dart' as _i17;
import 'package:auth_data/src/repositories/auth_repository_impl.dart' as _i700;
import 'package:auth_data/src/session/api_token_refresher.dart' as _i484;
import 'package:auth_data/src/session/auth_session.dart' as _i153;
import 'package:auth_data/src/session/token_refresher.dart' as _i310;
import 'package:auth_data/src/session/token_vault.dart' as _i1003;
import 'package:auth_domain/auth_domain.dart' as _i470;
import 'package:chopper/chopper.dart' as _i31;
import 'package:injectable/injectable.dart' as _i526;

const String _remote = 'remote';

class AuthDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i310.TokenRefresher>(
      () => _i484.ApiTokenRefresher(gh<_i633.ApiTransport>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i449.AuthApi>(
      () => _i449.AuthApi.createForDi(gh<_i31.ChopperClient>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i17.AuthNetworkDs>(
      () => _i17.AuthNetworkDs(gh<_i449.AuthApi>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i470.AuthRepository>(
      () => _i700.AuthRepositoryImpl.fromNetwork(gh<_i17.AuthNetworkDs>()),
      registerFor: {_remote},
    );
    gh.lazySingleton<_i353.Session>(
      () => _i153.AuthSession.create(
        gh<_i1003.TokenVault>(),
        gh<_i310.TokenRefresher>(),
        gh<_i153.AuthSessionConfig>(),
      ),
      registerFor: {_remote},
      dispose: _i153.disposeAuthSession,
    );
  }
}
