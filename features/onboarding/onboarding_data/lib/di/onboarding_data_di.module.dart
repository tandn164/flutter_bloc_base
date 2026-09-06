//@GeneratedMicroModule;OnboardingDataPackageModule;package:onboarding_data/di/onboarding_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:local_storage/local_storage.dart' as _i486;
import 'package:onboarding_data/src/stored_onboarding_repository.dart' as _i453;

class OnboardingDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i453.StoredOnboardingRepository>(() =>
        _i453.StoredOnboardingRepository.create(gh<_i486.KeyValueStore>()));
  }
}
