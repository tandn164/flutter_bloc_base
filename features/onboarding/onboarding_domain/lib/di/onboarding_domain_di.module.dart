//@GeneratedMicroModule;OnboardingDomainPackageModule;package:onboarding_domain/di/onboarding_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:onboarding_domain/src/onboarding_repository.dart' as _i954;
import 'package:onboarding_domain/src/onboarding_use_cases.dart' as _i812;

class OnboardingDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i812.ShouldShowOnboarding>(
        () => _i812.ShouldShowOnboarding(gh<_i954.OnboardingRepository>()));
    gh.lazySingleton<_i812.CompleteOnboarding>(
        () => _i812.CompleteOnboarding(gh<_i954.OnboardingRepository>()));
  }
}
