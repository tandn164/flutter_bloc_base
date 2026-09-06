import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:onboarding_data/di/onboarding_data_di.module.dart';
import 'package:onboarding_data/onboarding_data.dart';
import 'package:onboarding_domain/di/onboarding_domain_di.module.dart';
import 'package:onboarding_domain/onboarding_domain.dart';
import 'onboarding_di.config.dart';

Future<void> registerOnboardingDependencies(GetIt sl) async {
  await configureOnboardingDependencies(sl);
  if (sl.isRegistered<OnboardingRepository>()) return;
  sl.registerLazySingleton<OnboardingRepository>(
    () => sl<StoredOnboardingRepository>(),
  );
}

@InjectableInit(
  initializerName: 'initOnboardingFeature',
  generateForDir: ['lib/app/features/onboarding'],
  includeMicroPackages: false,
  externalPackageModulesBefore: [
    ExternalModule(OnboardingDataPackageModule),
    ExternalModule(OnboardingDomainPackageModule),
  ],
)
Future<void> configureOnboardingDependencies(GetIt container) async {
  await container.initOnboardingFeature();
}
