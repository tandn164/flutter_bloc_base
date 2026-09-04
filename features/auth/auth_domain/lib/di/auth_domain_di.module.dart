//@GeneratedMicroModule;AuthDomainPackageModule;package:auth_domain/di/auth_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:auth_domain/src/repositories/auth_repository.dart' as _i138;
import 'package:auth_domain/src/usecases/login.dart' as _i893;
import 'package:auth_domain/src/usecases/signup.dart' as _i568;
import 'package:injectable/injectable.dart' as _i526;

class AuthDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i893.LoginUseCase>(
        () => _i893.LoginUseCase(gh<_i138.AuthRepository>()));
    gh.lazySingleton<_i568.SignupUseCase>(
        () => _i568.SignupUseCase(gh<_i138.AuthRepository>()));
  }
}
