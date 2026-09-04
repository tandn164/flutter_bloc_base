//@GeneratedMicroModule;ProfileDomainPackageModule;package:profile_domain/di/profile_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_domain/src/repositories/profile_repository.dart'
    as _i515;
import 'package:profile_domain/src/usecases/profile_usecases.dart' as _i852;

class ProfileDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i852.GetProfile>(
        () => _i852.GetProfile(gh<_i515.ProfileRepository>()));
    gh.lazySingleton<_i852.UpdateProfile>(
        () => _i852.UpdateProfile(gh<_i515.ProfileRepository>()));
  }
}
